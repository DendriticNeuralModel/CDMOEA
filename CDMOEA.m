function [test_accuracy, logic_test_accuracy]=CDMOEA(input_train, target_train, input_test, target_test, MaxComplex, interval, overlap, NumSolutionSubproblem, M, PS)
%% Notion
Maxiteration=1000;
Pm=1;
disM=20;
F=0.7;
CR=0.9;
delta=0.85;
    
I=size(input_train,1);
D=2*I*M;%the size of individual
lu=[-10*ones(1,D);10*ones(1,D)];
%% preprocessing
[refPoints,R]=DecompositionMOInteger(overlap,interval,MaxComplex);
NumEndSubproblem=NumSolutionSubproblem;
if (refPoints(2,R)-refPoints(1,R)+1) < NumSolutionSubproblem
    NumEndSubproblem=(refPoints(2,R)-refPoints(1,R)+1);
end
popsize=(R-1)*NumSolutionSubproblem+NumEndSubproblem; 
T=max(floor(R/10),4);
%% MOEA
FES=0;
%now initialize the population
pop=repmat(lu(1, :), popsize, 1) + rand(popsize, D) .* (repmat(lu(2, :) - lu(1, :), popsize, 1));
%pop associated with subproblems
complex=zeros(1,popsize);
for p=1:popsize
    [~,complex(p)]=Complex(pop(p,:),I,M);
end
[pop,problemID]=repairindividualInteger(pop,refPoints,complex, NumSolutionSubproblem, NumEndSubproblem, I, M, R);
%compute the two objective
[erates,complex,~]=evaluate_MseComplex( input_train, target_train, pop, M, PS );
FES=FES+popsize;

%find T neighboring subproblems for earch subproblem
SubproblemID=1:R;
B = pdist2(SubproblemID',SubproblemID');
[~,B] = sort(B,2);
B = B(:,1:T);
while FES < (50*Maxiteration)
    perm=randperm(R);
    for p=1:R
        i=perm(p);
        Selected=zeros(1,size(pop,1));
        S1=get_solutionIndex(i,problemID,Selected);
        Selected(S1)=1;
        if rand < delta
            P = B(i,randperm(end));%P represents the member of neighboring problem;
            [S2,S3]=GetMatingSolution(P,problemID,R,Selected);
        else
            P = randperm(R);
            [S2,S3]=GetMatingSolution(P,problemID,R,Selected);
        end
        %Differential evolution
        Site = rand(1,D) < CR;
        Offspring       = pop(S1,:);
        Offspring(Site) = Offspring(Site) + F*(pop(S2,Site)-pop(S3,Site));
        % Polynomial mutation
        Lower = lu(1,:);
        Upper = lu(2,:);
        Site  = rand(1,D) < (Pm/D);
        mu    = rand(1,D);
        temp  = Site & mu<=0.5;
        Offspring       = min(max(Offspring,Lower),Upper);
        Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*((2.*mu(temp)+(1-2.*mu(temp)).*...
                          (1-(Offspring(temp)-Lower(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1))-1);
        temp = Site & mu>0.5; 
        Offspring(temp) = Offspring(temp)+(Upper(temp)-Lower(temp)).*(1-(2.*(1-mu(temp))+2.*(mu(temp)-0.5).*...
                          (1-(Upper(temp)-Offspring(temp))./(Upper(temp)-Lower(temp))).^(disM+1)).^(1/(disM+1)));
        Offspring       = min(max(Offspring,Lower),Upper);
        
        Offspring=reduceSizeInteger(Offspring,MaxComplex,I,M);%for avoiding solution with 0 complex or with bigger complex.
        [off_erates,off_complex,~]=evaluate_MseComplex( input_train, target_train, Offspring, M, PS );
        % Update pop 
        [pop,erates,complex,problemID]=updatesubproblemInteger(Offspring,off_erates,off_complex,pop,erates,complex,problemID, refPoints,R, NumSolutionSubproblem,NumEndSubproblem);
        FES=FES+1;
    end
end
whole_fit=[erates' complex'];
nodomi= non_domination( whole_fit, 2);
archive=pop(nodomi,:);
%% Evaluate the accuracy of ALNM
[accuracy_train, ~] = evaluate_accuracy(input_train, target_train, archive, M);
[~, index1] = max(accuracy_train);
[test_accuracy, ~] = evaluate_accuracy(input_test, target_test, archive(index1,:), M);

%% Evaluate the accuracy of the logic circuit classifier
[accuracy_logic_train, ~, ~] = evaluate_accuracy_logic_circuit( input_train, target_train, archive, M, PS);
[~, index2]=max(accuracy_logic_train);
[logic_test_accuracy, ~, ~] = evaluate_accuracy_logic_circuit( input_test, target_test, archive(index2,:), M, PS);

end


