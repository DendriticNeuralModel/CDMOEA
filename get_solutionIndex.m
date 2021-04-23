function [selectind]=get_solutionIndex(ID,problemID,Selected)
ind=find(problemID(ID,:)==1);
ind=ind(Selected(ind)==0);
if isempty(ind)
    selectind=0;
else
    ind=ind(1,randperm(end));
    selectind=ind(1);
end
end