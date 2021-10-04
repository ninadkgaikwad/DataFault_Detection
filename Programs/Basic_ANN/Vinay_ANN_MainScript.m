%% Vinay_ANN_MainScript

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

% Getting SensorDataLabelledMatrix from SensorDataMatrixLabelled_Cell

SensorDataLabelledMatrix=SensorDataMatrixLabelled_Cell{1,SensorGroup};

% Calling External Function for Feature Extraction

[ ExtractedFeatureMatrix, ANN_SensorData_Cell, SVM_SensorData_Cell] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix, WindowSize, Res );

%% Training ANN

% User Input

hiddenLayerSize=input('Enter the Hiddden Layer Architecture of the ANN [e.g. [5,5,5]]: ');

TrainFunc=input('Enter the Training Function to be used [e.g. ''trainlm'']: ');

TotalNets=input('Enter Toal number of ANN nets to be Trained: ');

% Calling External Function for Training the ANN

[ BestNet ] = WSN_ANN_Training_Vinay( ANN_SensorData_Cell, hiddenLayerSize, TrainFunc, TotalNets );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Feature Extraction from the Sensor Data

% Getting SensorDataLabelledMatrix from SensorDataMatrixLabelled_Cell

SensorDataLabelledMatrix1=SensorDataMatrixLabelled_Cell1{1,SensorGroup};

% Calling External Function for Feature Extraction

[ ExtractedFeatureMatrix1, ANN_SensorData_Cell1, SVM_SensorData_Cell1] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix1, WindowSize, Res );

%% Predicting Using Trained ANN

% Calling External Function for ANN Prediction

[ PredictedOutput_ANN ] = WSN_ANN_Prediction_Vinay( BestNet, ANN_SensorData_Cell1 );

%% Notes

% Training Function	 Algorithm
% 
% 'trainlm'	         Levenberg-Marquardt
% 
% 'trainbr'	         Bayesian Regularization
% 
% 'trainbfg'	     BFGS Quasi-Newton
% 
% 'trainrp'	         Resilient Backpropagation
% 
% 'trainscg'	     Scaled Conjugate Gradient
% 
% 'traincgb'	     Conjugate Gradient with Powell/Beale Restarts
% 
% 'traincgf'	     Fletcher-Powell Conjugate Gradient
% 
% 'traincgp'	     Polak-Ribiére Conjugate Gradient
% 
% 'trainoss'	     One Step Secant
% 
% 'traingdx'	     Variable Learning Rate Gradient Descent 
% 
% 'traingdm'	     Gradient Descent with Momentum
% 
% 'traingd'	         Gradient Descent