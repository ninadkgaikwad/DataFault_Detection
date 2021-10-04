%% PCA_Method_MainScript

%% Getting Sensor Data from Server for Training inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% User Inputs

UpperBound=input('Enter Upper Bound Vector for Sensor Data: ');

LowerBound=input('Enter Lower Bound Vector for Sensor Data: ');

RateOfChange=input('Enter the threshold Rate of Change Vector for Sensor Data: ');

SensorGroup=input('Enter Sensor Group Number for Sensor Data: ');

Res=input('Enter Time Resolution in minutes for Sensor Data: ');

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell, SensorTotalNum ] = WSN_DataLabelling_1( SensorDataMatrix, AC_Data, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Data Preparation for PCA Training

% User Input

CleanData_YesNo=input('Do you want to Clean Data [1: Yes ; 0: No]: ');

if (CleanData_YesNo==1)
    
    FaultyData_CorrectionAlgorithm=input('Which Clean Data Algorithm you wish to select [1: Using Sensor Regression Relationships ; 2: Discarding any sample with Fault]: ');

elseif (CleanData_YesNo==0)
    
    FaultyData_CorrectionAlgorithm=0;
    
end
% Calling External Function for Data Preparation

[ WSN_PCA_CleanData_Matrix_Training ] = WSN_PCA_DataPreparation_Training( SensorDataMatrixLabelled_Cell, SensorGroup, CleanData_YesNo, FaultyData_CorrectionAlgorithm );

%% Training PCA

% User Input

Normalization_YesNo=input('Do you want Data to be Normalized [1: Yes; 0: No]: ');

% Calling External Function for Training the PCA

[ ReducedOrder_PCAMatrix, ReducedOrder_PCAMatrix_Transpose, QValue_Threshold, Training_Averages, Training_SD] = WSN_PCA_Training( WSN_PCA_CleanData_Matrix_Training, Normalization_YesNo );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Data Preparation for PCA Prediction

% User Input

FeatureEnergySignal_YesNo=0;

WindowSize=input('Enter Window Size for sampling signals: ');

ContinuousWindow_YesNo=input('Do you want Data to be continuously windowed or not [1: Yes; 0: No]: ');

Normalization_TrainPredict=input('Do you want to predict Data using Averages and Standard Deviations from Training Process or Prediction Raw Data [1: Training Averages and Standard Deviations will be used; 0: Averages and Standard Deviations of Raw Data will be used will be used]: ');

% Calling External Function for Data Preparation

[  WSN_PCA_Predict_Normalized_DataCell ] = WSN_PCA_DataPreparation_Prediction( SensorDataMatrixLabelled_Cell1, WindowSize, ContinuousWindow_YesNo, FeatureEnergySignal_YesNo,Normalization_YesNo, Normalization_TrainPredict, Training_Averages, Training_SD);

%% Predicting Using Trained PCA-Wavelet

% Calling External Function for PCA Prediction

[ WSN_PCA_Predicted_Matrix, FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCA_Prediction(  WSN_PCA_Predict_Normalized_DataCell, ReducedOrder_PCAMatrix, ReducedOrder_PCAMatrix_Transpose, QValue_Threshold, Training_Averages, Training_SD, Normalization_YesNo )

