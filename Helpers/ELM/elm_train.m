function [TrainingTime,TrainingAccuracy] = elm_train(train_data, BlockType, NumberofHiddenNeurons, ActivationFunction)

%%%%%%%%%%% Load training dataset
T=train_data(:,1)';
P=train_data(:,2:size(train_data,2))';
clear train_data;                                   %   Release raw training data array

NumberofTrainingData=size(P,2);
NumberofInputNeurons=size(P,1);

%%%%%%%%%%%% Preprocessing the data of classification
sorted_target=sort(T,2);
label=zeros(1,1);                               %   Find and save in 'label' class label from training and testing data sets
label(1,1)=sorted_target(1,1);
j=1;
for i = 2:NumberofTrainingData
    if sorted_target(1,i) ~= label(1,j)
        j=j+1;
        label(1,j) = sorted_target(1,i);
    end
end
number_class=j;
NumberofOutputNeurons=number_class;

%%%%%%%%%% Processing the targets of training
temp_T=zeros(NumberofOutputNeurons, NumberofTrainingData);
for i = 1:NumberofTrainingData
    for j = 1:number_class
        if label(1,j) == T(1,i)
            break; 
        end
    end
    temp_T(j,i)=1;
end
T=temp_T*2-1;                                         %   end if of Elm_Type

%%%%%%%%%%% Calculate weights & biases
start_time_train=cputime;

%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
tempH=InputWeight*P;
clear P;                                            %   Release input of training data 
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH=tempH+BiasMatrix;

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid 
        H = 1 ./ (1 + exp(-tempH));
    case {'sin','sine'}
        %%%%%%%% Sine
        H = sin(tempH);          
        %%%%%%%% More activation functions can be added here                
end
clear tempH;                                        %   Release the temparary array for calculation of hidden neuron output matrix H                                    %   Release the temparary array for calculation of hidden neuron output matrix H

%%%%%%%%%%% Calculate output weights OutputWeight (beta_i)
OutputWeight=pinv(H') * T';
end_time_train=cputime;
TrainingTime=end_time_train-start_time_train;        %   Calculate CPU time (seconds) spent for training ELM

Y=(H' * OutputWeight)';                             %   Y: the actual output of the training data
clear H;

%%%%%%%%%%% Calculate the training accuracy

%%%%%%%%%% Calculate training & testing classification accuracy
MissClassificationRate_Training=0;

for i = 1 : size(T, 2)
    [x, label_index_expected]=max(T(:,i));
    [x, label_index_actual]=max(Y(:,i));
    output(i)=label(label_index_actual);
    if label_index_actual~=label_index_expected
        MissClassificationRate_Training=MissClassificationRate_Training+1;
    end
end
TrainingAccuracy=1-MissClassificationRate_Training/NumberofTrainingData;

ModelPath = cat(2, pwd(), "/elm_model_", BlockType, ".mat");
save(ModelPath, 'NumberofInputNeurons', 'NumberofOutputNeurons', 'InputWeight', 'BiasofHiddenNeurons', 'OutputWeight', 'ActivationFunction', 'label');