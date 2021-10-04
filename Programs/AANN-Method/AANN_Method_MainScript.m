%% AANN_Method_MainScript

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

%% Training AANN

% User Input

Mode=input('Enter Mode [Options: 1 or 2 or 3] for Data Preparation: ');

NetType=input('Enter ANN Net Type [Options: 1 or 2 or 3]: ');

hiddenLayerSize=input('Enter the Hiddden Layer Architecture of the ANN [e.g. [5,5,5]]: ');

TrainFunc=input('Enter the Training Function to be used [e.g. ''trainlm'']: ');

TotalNets=input('Enter Toal number of ANN nets to be Trained: ');

% Calling External Function for Training the ANN

[ BestNet_AANN,AANN_FaultCriterion ] = WSN_AANN_Training( ANN_SensorData_Cell, Mode, NetType, hiddenLayerSize, TrainFunc, TotalNets );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Feature Extraction from the Sensor Data

% Getting SensorDataLabelledMatrix from SensorDataMatrixLabelled_Cell

SensorDataLabelledMatrix1=SensorDataMatrixLabelled_Cell1{1,SensorGroup};

% Calling External Function for Feature Extraction

[ ExtractedFeatureMatrix1, ANN_SensorData_Cell11, SVM_SensorData_Cell1] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix1, WindowSize, Res );


%% Predicting Using Trained AANN

% Calling External Function for ANN Prediction

[PredicteOutput_AANN, AANN_FaultLabel_Matrix1, AANN_FaultLabel_Matrix2,AANN_Performance_Cell  ] = WSN_AANN_Prediction( BestNet_AANN, AANN_FaultCriterion, ANN_SensorData_Cell1, Mode);

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
% 'traingd'	     

% Mode Description

% Mode==1 : All Extracted Features vs All Extracted Features
% Mode==2 : Only Measured Value
% Mode==3 : All Extracted Features vs Measured Value

% NetType Description

% NetType==1 : fitnet Function is used
% NetType==2 : feedforwardnet Function is used
% NetType==3 : cascadeforwardnet Function is used
