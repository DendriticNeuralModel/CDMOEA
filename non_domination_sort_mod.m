function KeepIndex = non_domination_sort_mod( fitness, M, NumSolutionSubproblem)
%M is the number of objective.
%fitness---popsize * M
KeepIndex=[];
x= fitness;
[N, ~] = size(x);
clear m

% Initialize the front number to 1.
front = 1;

% There is nothing to this assignment, used only to manipulate easily in MATLAB.
%F(front).f is used to the relationship between individuals.
F(front).f = [];     individual = [];

for i = 1 : N
    individual(i).n = 0;        % Number of individuals that dominate this individual
    individual(i).p = [];       % Individuals which this individual dominate
    for j = 1 : N
        dom_less = 0;
        dom_equal = 0;
        dom_more = 0;
        for k = 1 : M
            if (x(i,k) < x(j,k))
                dom_less = dom_less + 1;
            elseif (x(i,k) == x(j,k))
                dom_equal = dom_equal + 1;
            else
                dom_more = dom_more + 1;
            end
        end
        if dom_less == 0 && dom_equal ~= M
            individual(i).n = individual(i).n + 1;
        elseif dom_more == 0 && dom_equal ~= M
            individual(i).p = [individual(i).p j];%this method that make j become a element in individual(i).p.
        end
    end
    if individual(i).n == 0
        x(i,M + 1) = 1;%this means that the size of x can be enlarged in MATLAB.This is to say,x->(population_size,number_objective+rank)
        F(front).f = [F(front).f i];
    end
end

% Find the subsequent fronts, this method is  analogous to cut the root of a tree,and then get more than root points.
while ~isempty(F(front).f)
   Q = [];
   for i = 1 : length(F(front).f)   %L = length(X) returns the length of the largest array dimension in X. 
       if ~isempty(individual(F(front).f(i)).p)
            for j = 1 : length(individual(F(front).f(i)).p)
            	individual(individual(F(front).f(i)).p(j)).n = individual(individual(F(front).f(i)).p(j)).n - 1;
        	    if individual(individual(F(front).f(i)).p(j)).n == 0
               		x(individual(F(front).f(i)).p(j),M + 1) = front + 1;
                    Q = [Q individual(F(front).f(i)).p(j)];
                end
            end
       end
   end
   front =  front + 1;
   F(front).f = Q;% note:at the end,F(front).f=[], so the true length is length(F)-1.
end
%determine the index of conserved solutions needed by the algorithm.
NeedAddition=NumSolutionSubproblem;
for front = 1 : (length(F) - 1)
    if length(F(front).f)<=NeedAddition
       KeepIndex=[KeepIndex F(front).f];
       NeedAddition=NeedAddition-length(F(front).f);
    else
        break;
    end
end
%indicate that too much solution in the certain front.
if NeedAddition > 0
    y = zeros(length(F(front).f),M+1);
    %this 'front' layer should be process according to the crowding criterion
    for i = 1 : length(F(front).f) 
        y(i,:) = x(F(front).f(i),:);
    end
    
    % Sort each individual based on the objective
    for i = 1 : M
        [~, index_of_objectives] = sort(y(:,i));
        sorted_based_on_objective = [];
        for j = 1 : length(index_of_objectives)
            sorted_based_on_objective(j,:) = y(index_of_objectives(j),:);
        end
        f_max = sorted_based_on_objective(length(index_of_objectives), i);
        f_min = sorted_based_on_objective(1,i);
        y(index_of_objectives(length(index_of_objectives)),M + 1 + i) = Inf;
        y(index_of_objectives(1),M + 1 + i) = Inf;
        
        for j = 2 : length(index_of_objectives) - 1
            next_obj  = sorted_based_on_objective(j + 1,i);
            previous_obj  = sorted_based_on_objective(j - 1,i);
            if (f_max - f_min == 0)
                y(index_of_objectives(j),M + 1 + i) = Inf;
            else
                y(index_of_objectives(j),M + 1 + i) = (next_obj - previous_obj)/(f_max - f_min);% the intreval between previous_obj and next_obj acts as crowding degree in this individual. 
            end
        end
    end
    distance = [];% define a empty maxtric
    distance(:,1) = zeros(length(F(front).f),1);
    for i = 1 : M
        distance(:,1) = distance(:,1) + y(:,M + 1 + i);
    end
    y(:,M + 2) = distance;
    y = y(:,1 : M + 2);
    [~, distance_Index]=sort(y(:,M+2),'descend');
    KeepIndex=[KeepIndex F(front).f(distance_Index(1:NeedAddition))];
end

end

