function [pop,problemID]=repairindividualInteger(pop,refPoints,complex, NumSolutionSubproblem, NumEndSubproblem, I, M, R)
%Ref is relative with pop.
%refPoints is the upper and lower bound of all subproblems.
popsize=size(pop,1);
problemID=zeros(R,popsize);
for r=1:R
    bound=refPoints(1,r):refPoints(2,r);
    Temp=bound(1,randperm(end));
    if r==R
        NumSolutionr=NumEndSubproblem;
    else
        NumSolutionr=NumSolutionSubproblem;
    end
    ComplexVector=Temp(1:NumSolutionr);
    for p=1:NumSolutionr
        index=NumSolutionSubproblem*(r-1)+p;%the index of solution 
        TargetComplex=ComplexVector(p);
        %assure that solution with specific complex.
        if complex(index) < TargetComplex
            pop(index,:)=increaseSizeInteger(pop(index,:), TargetComplex, I, M);
        else
            if complex(index) > TargetComplex
                pop(index,:)=reduceSizeInteger(pop(index,:), TargetComplex,I,M);
            end
        end 
        StartIndex=find(refPoints(2,:)>=TargetComplex,1);%the smallest Subordinate subproblem
        EndIndex=StartIndex;%the biggest Subordinate subproblem.
        for pID=(StartIndex+1):R
            if refPoints(1,pID)<=TargetComplex
                EndIndex=EndIndex+1;
            else
                break;
            end
        end
        problemID(StartIndex:EndIndex,index)=1;     
    end
end
end