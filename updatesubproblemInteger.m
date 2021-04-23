function [pop,erates,complex,problemID]=updatesubproblemInteger(child,suberates,subcomplex,pop,erates,complex,problemID, refPoints,R, NumSolutionSubproblem, NumEndSubproblem)
%judge which suproblem includes child.
StartIndex=find(refPoints(2,:)>=subcomplex,1);%the smallest Subordinate subproblem
EndIndex=StartIndex;%the biggest Subordinate subproblem.
for r=StartIndex+1:R
    if refPoints(1,r)<=subcomplex
        EndIndex=EndIndex+1;
    else
        break;
    end
end
RecordeChild=0;
for i=StartIndex:EndIndex
    candidateIndivIDs=find(problemID(i,:)==1);
    Temp_erates=[erates(candidateIndivIDs) suberates];
    Temp_complex=[complex(candidateIndivIDs) subcomplex];
    N=length(Temp_erates);
    replace=ones(1,N);
    %select better solutions according to pareto set.
    whole_fit=[Temp_erates' Temp_complex'];
    if i==R
        KeepNum=NumEndSubproblem;
    else
        KeepNum=NumSolutionSubproblem;
    end
    nodomi=non_domination_sort_mod( whole_fit, 2, KeepNum);
    replace(nodomi)=0;
    %remove old solutions which are dominated.
    delete=candidateIndivIDs( replace(1:(N-1))==1 );
    %calculate how much subproblems each solution  locates on.
    NumDelete=sum(problemID(:,delete));
    %formal deletion
    problemID(i,delete(NumDelete>1))=0;
    %true deletion
    pop(delete(NumDelete==1),:)=[];
    erates(delete(NumDelete==1))=[];
    complex(delete(NumDelete==1))=[];
    problemID(:,delete(NumDelete==1))=[];
    
    if replace(N)==0 
        if RecordeChild==0
            pop=[pop;child];
            complex=[complex subcomplex];
            erates=[erates suberates];
            tempID=zeros(R,1);
            tempID(i)=1;
            problemID=[problemID tempID];
            RecordeChild=1;
        else
            problemID(i,end)=1;
        end 
    end
end

end


