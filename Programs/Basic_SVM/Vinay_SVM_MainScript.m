%% Vinay_SVM_MainScript

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

%% Performing Feature Extraction from the Sensor Data

% User Input

WindowSize=input('Enter Window Size for Feature Extraction: ');

% Calling External Function for Feature Extraction

[ ExtractedFeatureMatrix, ANN_SensorData_Cell, SVM_SensorData_Cell] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix, WindowSize, Res );

%% Training SVM

% User Input

KernelFunction=input('Enter the Kernal Function for SVM [e.g. ''rbf'']: ');

if (KernelFunction=='polynomial')
    
    PolyOrder=input('Enter the the Polynoial Order: ');
    
else
    
    PolyOrder=0;
    
end

% Calling External Function for Training the SVM

[ Trained_SVM, SVM_Performance_Cell ] = WSN_SVM_Training_Vinay( SVM_SensorData_Cell, KernelFunction, PolyOrder );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Feature Extraction from the Sensor Data

% Calling External Function for Feature Extraction

[ ExtractedFeatureMatrix1, ANN_SensorData_Cell1, SVM_SensorData_Cell1] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix1, WindowSize, Res );

%% Predicting Using Trained SVM

% Calling External Function for SVM Prediction

[ Predicted_Output_SVM, SVM_Performance_Cell ] = WSN_SVM_Prediction_Vinay( Trained_SVM, SVM_SensorData_Cell1 );

%% Notes

% Types of SVM Kernal Functions

% Radial Bias Function == 'rbf'
% Linear Function == 'linear'
% Polynomial Function == 'polynomial'
