function [ WSN_ANNWavelet_BestNets_Cell, WSN_ANNWavelet_FaultCriterion_VarianceValue , SignalPrediction_Possibilty_YesNo] = WSN_ANNWavelet_Training( WSN_ANNWavelet_InputTrain_DataCell, WSN_ANNWavelet_TargetTrain_DataCell, SignalPrediction_Possibilty_YesNo, NetType, hiddenLayerSize, TrainFunc, TotalNets )
%% Function Input and Output Argument Description:

% Input Arguments:

% WSN_ANNWavelet_InputTrain_DataCell : 
% WSN_ANNWavelet_TargetTrain_DataCell : 
% SignalPrediction_Possibilty_YesNo : 
% NetType : 
% hiddenLayerSize :
% TrainFunc :
% TotalNets :

% Output Arguments:

% WSN_ANNWavelet_BestNet :
% WSN_ANNWavelet_FaultCriterion_VarianceValue  :
% SignalPrediction_Possibilty_YesNo :

%% The Code

% Getting the size of WSN_ANNWavelet_InputTrain_DataCell

[R,C]=size(WSN_ANNWavelet_InputTrain_DataCell);

% Getting Inputs and Targets for Training

Inputs=ANN_SensorData_Cell{1,1};

Targets=ANN_SensorData_Cell{1,2};

inputs = Inputs';
targets = Targets';

% Create a ANN based on NetType

if (NetType==1) % Fitnet
    
    net = fitnet(hiddenLayerSize,TrainFunc);
    
elseif(NetType==2) % Feedforwardnet
    
    net = feedforwardnet(hiddenLayerSize,TrainFunc);
    
elseif(NetTypeNetType==3) % Cascadeforwardnet
    
    net = cascadeforwardnet(hiddenLayerSize,TrainFunc);
    
end

% View the Network
view(net)

% Creating Cell Array for Storing Multiple Nets and TRs

Net_Cell=cell(C,TotalNets);

TR_Cell=cell(C,TotalNets);

% Train the Networks

for j=1:C

    inputs=WSN_ANNWavelet_InputTrain_DataCell{1,j};

    targets=WSN_ANNWavelet_TargetTrain_DataCell{1,j};

    for i=1:TotalNets
        
        [net,tr] = train(net,inputs,targets);

        Net_Cell(j,i)=net;

        TR_Cell(j,i)=tr;

    end
    
end

% Creating Output and Error Cell

Output_Cell=cell(C,TotalNets);

Error_Cell=cell(C,TotalNets);
    
% Testing the Networks

for j=1:C

    for i=1:TotalNets

        net=Net_Cell{j,i};

        outputs = net(inputs);

        errors = gsubtract(targets,outputs);

        Output_Cell(j,i)=outputs;

        Error_Cell(j,i)=errors;    

    end
    
end

% ANN Performance Plots

Status=[1,1]; % Initializing Index for plotting Performance Plots of the First Net

while((Status(1,1)<=C)&&(Status(1,2)<=TotalNets))
    
    % Getting the correct Errors, Outputs and TRs
    
    tr=TR_Cell{Status(1,1),Status(1,2)};
    
    errors=Error_Cell{Status(1,1),Status(1,2)};
    
    outputs=Output_Cell{Status(1,1),Status(1,2)};
    
    % Plotting Performance Plots of desired Net
    
    figure(1), plotperform(tr)
    figure(2), plottrainstate(tr)
    figure(3), ploterrhist(errors)
    figure(4), plotroc(targets,outputs)
    figure(5), plotconfusion(targets,outputs)
    
    % Asking User for Net Number for viewing Performance Plots of desired Net
    
    Status=input('Enter [Sensor Number, Net Number] for Getting Performance Plots: ');
    
    % Closing the previous Figures
    
    close(1);
    close(2);
    close(3);
    close(4);
    close(5);
    
end

BestNets_Index=input('Enter the index of the Best Performing Nets: ');

% Initializing WSN_ANNWavelet_BestNets

WSN_ANNWavelet_BestNets_Cell=cell(1,C);

% Getting the Best Nets

for i=1:C

WSN_ANNWavelet_BestNets_Cell(1,i)={Net_Cell{i,BestNets_Index(1,i)}};

end

% Getting the Performance from the Best Nets

Outputs_Cell=cell(1,C);

for i=1:C
   
    % Getting Inputs 
    
    Inputs=WSN_ANNWavelet_InputTrain_DataCell{1,l};
    
    % Getting Best Net
    
    Net=WSN_ANNWavelet_BestNets_Cell{1,i};
    
    Outputs=Net(Inputs);
    
    Outputs_Cell(1,i)={Outputs};
    
end

% Computing the Fault Criterion : Calling External Function

[ WSN_ANNWavelet_FaultCriterion_VarianceValue ] = WSN_ANNWavelet_FaultCriterion_Calculation( WSN_ANNWavelet_TargetTrain_DataCell, Outputs_Cell );

end

