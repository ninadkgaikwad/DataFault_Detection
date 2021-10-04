function [ BestNet_AANN,AANN_FaultCriterion ] = WSN_AANN_Training( ANN_SensorData_Cell, Mode, NetType, hiddenLayerSize, TrainFunc, TotalNets )
%% Function Input and Output Argument Description:

% Input Arguments:

% ANN_SensorData_Cell : 
% Mode : 
% NetType : 
% hiddenLayerSize : 
% TrainFunc :
% TotalNets :

% Output Arguments:

% BestNet_AANN :
% AANN_FaultCriterion :

%% The Code

% Getting Contents of ANN_SensorData_Cell

Data=ANN_SensorData_Cell{1,1};

Labels=ANN_SensorData_Cell{1,2};

% Mode-Wise Data Preparation for AANN : Calling External Function

[ Inputs, Targets ] = WSN_AANN_ModeWise_DataPreparation_Training( Data, Labels, Mode );

% Getting Inputs and Targets in correct form

inputs=Inputs';

targets=Targets';

% Creating AANN Net as per desired Type

if (NetType==1) % fitnet
    
    net = fitnet(hiddenLayerSize,TrainFunc);
        
elseif (NetType==1) % feedforwardnet
    
    net = feedforwardnet(hiddenLayerSize,TrainFunc);
    
elseif (NetType==1) % cascadeforwardnet
    
    net = cascadeforwardnet(hiddenLayerSize,TrainFunc);
    
end

% View the Network

view(net);

% Creating Cell Array for Storing Multiple Nets and TRs

Net_Cell=cell(1,TotalNets);

TR_Cell=cell(1,TotalNets);

% Train the Networks

for i=1:TotalNets
    
    [net,tr] = train(net,inputs,targets);
    
    Net_Cell(1,i)=net;
    
    TR_Cell(1,i)=tr;
    
end

% Creating Output and Error Cell

Output_Cell=cell(1,TotalNets);

Error_Cell=cell(1,TotalNets);
    
% Testing the Networks

for i=1:TotalNets
    
    net=Net_Cell{1,i};
    
    outputs = net(inputs);
    
    errors = gsubtract(targets,outputs);
    
    Output_Cell(1,i)=outputs;
    
    Error_Cell(1,i)=errors;    
    
end

% ANN Performance Plots

Status=1; % Initializing Index for plotting Performance Plots of the First Net

while(Status<=TotalNets)
    
    % Getting the correct Errors, Outputs and TRs
    
    tr=TR_Cell{1,Status};
    
    errors=Error_Cell{1,Status};
    
    outputs=Output_Cell{1,Status};
    
    % Plotting Performance Plots of desired Net
    
    figure(1), plotperform(tr)
    figure(2), plottrainstate(tr)
    figure(3), ploterrhist(errors)
    figure(4), plotregression(targets,outputs)
    % Asking User for Net Number for viewing Performance Plots of desired Net
    
    Status=input('Enter Net Number for Getting Performance Plots: ');
    
    % Closing the previous Figures
    
    close(1);
    close(2);
    close(3);
    close(4);
        
end

BestNet_Index=input('Enter the index of the Best Performing Net: ');

BestNet_AANN=Net_Cell{1,BestNet_Index};

% Prediction Using BestNet

output=BestNet_AANN(inputs);

Output=output';

% Getting ErrorTolerance from User

ErrorTolerance=input('Enter Error Tolerance Multiple: ');

% Calculating Fault Criterion : Calling External Function

[ AANN_FaultCriterion ] = WSN_AANN_FaultCriterion_Calculation( Output, Inputs, Mode, ErrorTolerance );


end

