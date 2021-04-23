function [refPoints,SubproNumber]=DecompositionMOInteger(overlap,interval,MaxComplex)
%overlap,interval,MaxComplex------ a integer
%Noting that refPoints(1,1)=1; refPoints(1,:) are always less than MaxComplex; refPoints(2,end)=MaxComplex.
refPoints(:,1)=[1;interval];
EndComplex=interval;
SubproNumber=1;
while EndComplex<MaxComplex
    SubproNumber=SubproNumber+1;
    refPoints(:,SubproNumber)=[EndComplex-overlap+1;interval+(EndComplex-overlap+1)-1];
    EndComplex=interval+(EndComplex-overlap+1)-1;
end
if refPoints(2,SubproNumber)>MaxComplex
    refPoints(2,SubproNumber)=MaxComplex;
end
end
