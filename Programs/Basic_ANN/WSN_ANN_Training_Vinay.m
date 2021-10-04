function [ BestNet ] = WSN_ANN_Training_Vinay( ANN_SensorData_Cell, hiddenLayerSize, TrainFunc, TotalNets )
%% Function Input and Output Argument Description:

% Input Arguments:

% ANN_SensorData_Cell : 
% hiddenLayerSize : 
% TrainFunc :
% TotalNets :

% Output Arguments:

% BestNet :


%% The Code

% Getting Inputs and Targets for Training

Inputs=ANN_SensorData_Cell{1,1};

Targets=ANN_SensorData_Cell{1,2};

inputs = Inputs';
targets = Targets';

% Create a Pattern Recognition Network

net = patternnet(hiddenLayerSize,TrainFunc);

% View the Network
view(net)

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
    figure(4), plotroc(targets,outputs)
    figure(5), plotconfusion(targets,outputs)
    
    % Asking User for Net Number for viewing Performance Plots of desired Net
    
    Status=input('Enter Net Number for Getting Performance Plots: ');
    
    % Closing the previous Figures
    
    close(1);
    close(2);
    close(3);
    close(4);
    close(5);
    
end

BestNet_Index=input('Enter the index of the Best Performing Net: ');

BestNet=Net_Cell{1,BestNet_Index};


end

