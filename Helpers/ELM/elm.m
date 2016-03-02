function output = elm(test_data, BlockType)

%%%%%%%%%%% Load testing dataset
TV.P=test_data';
clear test_data;                                    %   Release raw testing data array

output = [];

NumberofTestingData=size(TV.P,2);

ModelPath = cat(2, pwd(), "/elm_model_", BlockType, ".mat");
load(ModelPath);                                          %   end if of Elm_Type

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;
tempH_test=InputWeight*TV.P;
clear TV.P;             %   Release input of testing data             
ind=ones(1,NumberofTestingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH_test=tempH_test + BiasMatrix;

switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H_test = 1 ./ (1 + exp(-tempH_test));
    case {'sin','sine'}
        %%%%%%%% Sine
        H_test = sin(tempH_test);       
        %%%%%%%% More activation functions can be added here        
end

TY=(H_test' * OutputWeight)';                       %   TY: the actual output of the testing data
end_time_test=cputime;
TestingTime=end_time_test-start_time_test;          %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data

%%%%%%%%%% Calculate training & testing classification accuracy
MissClassificationRate_Testing=0;

for i = 1 : size(TV.P, 2)
    [x, label_index_actual]=max(TY(:,i));
    output(i)=label(label_index_actual);
end