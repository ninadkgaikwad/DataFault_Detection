function [ Predicted_Output_SVM, SVM_Performance_Cell ] = WSN_SVM_Prediction_Vinay( Trained_SVM, SVM_SensorData_Cell )
%% Function Input and Output Argument Description:

% Input Arguments:

% Trained_SVM : 
% SVM_SensorData_Cell : 

% Output Arguments:

% Predicted_Output_SVM :
% SVM_Performance_Cell :

%% The Code

% Getting Inputs and Targets for Training

Inputs=SVM_SensorData_Cell{1,1};

Targets=SVM_SensorData_Cell{1,2};

inputs = Inputs;
targets = Targets;

% Prediction using Trained SVM

[Predicted_Output_SVM] = predict(Trained_SVM,Inputs);

% Performance of Prediction : Calling External Function

[ Confusion_Matrix_Values, Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy ] = WSN_ConfusionMatrix_BinaryClassification( Outputs, Targets, Target_Vector );

SVM_Performance_Cell={Confusion_Matrix_Values,Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy};

end

