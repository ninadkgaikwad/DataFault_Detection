function [PredicteOutput_AANN, AANN_FaultLabel_Matrix1, AANN_FaultLabel_Matrix2,AANN_Performance_Cell  ] = WSN_AANN_Prediction( BestNet_AANN, AANN_FaultCriterion, ANN_SensorData_Cell, Mode)
%% Function Input and Output Argument Description:

% Input Arguments:

% BestNet_AANN : 
% ANN_SensorData_Cell : 

% Output Arguments:

% PredictedOutput :
% AANN_FaultLabel_Matrix1:
% AANN_FaultLabel_Matrix2:
% AANN_Performance_Cell  :

%% The Code

% Getting Contents of ANN_SensorData_Cell

Data=ANN_SensorData_Cell{1,1};

Labels=ANN_SensorData_Cell{1,2};

% Mode-Wise Data Preparation for AANN : Calling External Function

[ Inputs, Targets ] = WSN_AANN_ModeWise_DataPreparation_Prediction( Data, Mode );

% Getting Inputs and Targets in correct form

inputs=Inputs';

targets=Targets';

% Prediction using Trained Net

outputs=BestNet_AANN(inputs);

% Output Argument creation    

PredicteOutput_AANN=outputs';

% Fault Detection Using Fault Criterion : Calling External Function

[ AANN_FaultLabel_Matrix1, AANN_FaultLabel_Matrix2] = WSN_AANN_FaultDetection( inputs, outputs, Mode, AANN_FaultCriterion );
    
% Performance of Prediction : Calling External Function

[ Confusion_Matrix_Values, Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy ] = WSN_AANN_ConfusionMatrix_BinaryClassification( AANN_FaultLabel_Matrix1, Labels);

AANN_Performance_Cell={Confusion_Matrix_Values,Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy};

end

