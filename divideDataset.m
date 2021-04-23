% Start
function [ input_train, target_train, input_test, target_test, denNumber, PS ] = divideDataset( F_index, divide_rate)
switch  F_index

%%%   Binary  classification problem     
    case 1
        load ./dataset/liver.mat
        input=liver(1:6,:);
        target=liver(7,:);
        denNumber=9;
    case 2
        load cancer_dataset
        input=cancerInputs;
        target=cancerTargets(1,:);
        denNumber=15;
end
r=length(target);
[A,~,C] = dividerand(r,divide_rate,0,1-divide_rate);
input_train=input(:,A);         input_test=input(:,C);
target_train=target(:,A);       target_test=target(:,C);

[input_train, PS]=mapminmax(input_train,0,1);
input_test = mapminmax('apply', input_test, PS);
end
% Over

