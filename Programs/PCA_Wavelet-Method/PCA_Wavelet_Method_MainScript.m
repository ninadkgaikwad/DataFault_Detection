%% PCA_Wavelet_Method_MainScript

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

%% Performing Data Preparation for PCA-Wavelet Training

% User Input

FaultyData_YesNo=input('Do you want Faulty Data to be corrected [1: Yes; 0: No]: ');

WindowSize=input('Enter Window Size for sampling signals: ');

ContinuousWindow_YesNo=input('Do you want Data to be continuously windowed or not [1: Yes; 0: No]: ');

Wavelet_Level=input('Enter Level for Wavelet Decomposition: ');

Wavelet_Filter=input('Enter Wavelet Filter for Wavelet Decomposition {e.g. ''db1''}: ');

% Calling External Function for Data Preparation

[ WSN_PCAWavelet_CleanData_Matrix_Training ] = WSN_PCAWavelet_DataPreparation_Training( SensorDataMatrixLabelled_Cell, SensorGroup, FaultyData_YesNo, WindowSize, ContinuousWindow_YesNo, Wavelet_Level, Wavelet_Filter );

%% Training PCA-Wavelet

% User Input

Normalization_YesNo=input('Do you want Data to be Normalized [1: Yes; 0: No]: ');

% Calling External Function for Training the PCA-Wavelet

[ ReducedOrder_PCAWavelet_Matrix, ReducedOrder_PCAWavelet_Matrix_Transpose, QValue_Threshold, Training_Averages, Training_SD ] = WSN_PCAWavelet_Training( WSN_PCAWavelet_CleanData_Matrix_Training, Normalization_YesNo );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Data Preparation for PCA-Wavelet Prediction

% User Input

Normalization_TrainPredict=input('Do you want to predict Data using Averages and Standard Deviations from Training Process or Prediction Raw Data [1: Training Averages and Standard Deviations will be used; 0: Averages and Standard Deviations of Raw Data will be used will be used]: ');

% Calling External Function for Data Preparation

[  WSN_PCAWavelet_Predict_Normalized_DataCell,WSN_PCAWavelet_TargetOriginal_DataCell ] = WSN_PCAWavelet_DataPreparation_Prediction( SensorDataMatrixLabelled_Cell1, WindowSize, ContinuousWindow_YesNo, Wavelet_Level, Wavelet_Filter, FeatureEnergySignal_YesNo, Normalization_YesNo, Normalization_TrainPredict, Training_Averages, Training_SD );

%% Predicting Using Trained PCA-Wavelet

% Calling External Function for PCA-Wavelet Prediction

[  WSN_PCAWavelet_Predicted_Matrix, WSN_PCAWavelet_Predicted_OriginalSignal_Matrix, FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCAWavelet_Prediction( WSN_PCAWavelet_Predict_Normalized_DataCell,WSN_PCAWavelet_TargetOriginal_DataCell, ReducedOrder_PCAWavelet_Matrix, ReducedOrder_PCAWavelet_Matrix_Transpose, QValue_Threshold, Training_Averages, Training_SD, Normalization_YesNo, Wavelet_Level, Wavelet_Filter  );

%% Notes

% Available Wavelet Filters

% Daubechies
% 'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% Coiflets
% 'coif1', ... , 'coif5'
% Symlets
% 'sym2', ... , 'sym8', ... ,'sym45'
% Fejer-Korovkin filters
% 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% Discrete Meyer
% 'dmey'
% Biorthogonal
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% Reverse Biorthogonal
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'


