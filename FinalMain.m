clc
clear
tic

F_index = 1;              % Problem number
Ratio = 0.7;              % Ratio of the training and testing data sets
Drop=1;
intervalratio=0.1;
overlapratio=intervalratio*0.5;
NumSRatio=intervalratio*0.5;
     
%% Split into training and test sets
[ input_train, target_train, input_test, target_test, denNumber, PS ] = divideDataset( F_index, Ratio);     % divide the dataset into two subpopulation
I=size(input_train,1);
MaxComplex=floor(Drop*I*denNumber);

%% Evaluate the model           
interval=max(floor(intervalratio*MaxComplex),2);%because overlap is at lest 1.
overlap=max(floor(overlapratio*MaxComplex),1);
NumSolutionSubproblem=max(floor(NumSRatio*MaxComplex),1);

[test_accuracy, test_logic_accuracy] = CDMOEA(input_train, target_train, input_test, target_test, MaxComplex, interval, overlap, NumSolutionSubproblem, denNumber, PS);

toc;
