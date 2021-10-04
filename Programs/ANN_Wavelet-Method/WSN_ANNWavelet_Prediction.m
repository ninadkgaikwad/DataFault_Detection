function [ Outputs_Cell, WSN_ANNWavelet_FaultDetection_Matrix ] = WSN_ANNWavelet_Prediction( WSN_ANNWavelet_InputPredict_DataCell, WSN_ANNWavelet_TargetPredict_DataCell, SignalPrediction_Possibilty_YesNo, WSN_ANNWavelet_BestNets_Cell, WSN_ANNWavelet_FaultCriterion_VarianceValue )
%% Function Input and Output Argument Description:

% Input Arguments:

% WSN_ANNWavelet_InputPredict_DataCell : 
% WSN_ANNWavelet_TargetPredict_DataCell : 
% SignalPrediction_Possibilty_YesNo : 
% WSN_ANNWavelet_BestNets_Cell : 
% WSN_ANNWavelet_FaultCriterion_VarianceValue : 

% Output Arguments:

% Outputs_Cell :
% WSN_ANNWavelet_FaultDetection_Matrix  :

%% The Code

% Getting Size of WSN_ANNWavelet_InputPredict_DataCell

[R,C]=size(WSN_ANNWavelet_InputPredict_DataCell);

% Getting the Performance from the Best Nets

Outputs_Cell=cell(1,C);

for i=1:C
   
    % Getting Inputs 
    
    Inputs=WSN_ANNWavelet_InputPredict_DataCell{1,l};
    
    % Getting Best Net
    
    Net=WSN_ANNWavelet_BestNets_Cell{1,i};
    
    Outputs=Net(Inputs);
    
    Outputs_Cell(1,i)={Outputs};
    
end

% Fault Detection: Calling External Function

[ WSN_ANNWavelet_FaultDetection_Matrix ] = WSN_ANNWavelet_FaultDetection( WSN_ANNWavelet_TargetPredict_DataCell, Outputs_Cell, WSN_ANNWavelet_BestNets_Cell, WSN_ANNWavelet_FaultCriterion_VarianceValue);

end

