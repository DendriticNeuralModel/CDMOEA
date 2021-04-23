function [S1,S2]=GetMatingSolution(P,problemID,R,Selected)
S1=get_solutionIndex(P(1),problemID,Selected);
T=length(P);
Ng=1;
while S1==0 && Ng<(T-1)
    Ng=Ng+1;
    S1=get_solutionIndex(P(Ng),problemID,Selected);
end
if S1==0 %to select S1 and S2 in all of subproblems.
    B=1:R;
    B(P(1:T-1))=[];
    P = B(1,randperm(end));
    T=length(P);
    S1=get_solutionIndex(P(1),problemID,Selected);
    Ng=1;
    while S1==0 && Ng<(T-1)
        Ng=Ng+1;
        S1=get_solutionIndex(P(Ng),problemID,Selected);
    end
    if S1==0
        disp('S1 do not be found in the (R-1) subproblems!');
        return;
    else
        Selected(S1)=1;
    end
    Ng=Ng+1;
    S2=get_solutionIndex(P(Ng),problemID,Selected);
    while S2==0 && Ng<T 
        Ng=Ng+1;
        S2=get_solutionIndex(P(Ng),problemID,Selected);
    end
    if S2==0
        disp('all solutions locates in the two subproblem!');
        return;
    else
        Selected(S2)=1;
    end
else %to select S2 in the next Neighbor
    Selected(S1)=1;
    Ng=Ng+1;
    S2=get_solutionIndex(P(Ng),problemID,Selected);
    while S2==0 && Ng<T
        Ng=Ng+1;
        S2=get_solutionIndex(P(Ng),problemID,Selected);
    end
    if S2==0
        B=1:R;
        B(P)=[];
        P = B(1,randperm(end));
        T=length(P);
        S2=get_solutionIndex(P(1),problemID,Selected);
        Ng=1;
        while S2==0 && Ng<T
            Ng=Ng+1;
            S2=get_solutionIndex(P(Ng),problemID,Selected);
        end
        if S2==0
            disp('all solutions locates in the two subproblem!');
            return;
        else
            Selected(S2)=1;
        end
    end
end
end