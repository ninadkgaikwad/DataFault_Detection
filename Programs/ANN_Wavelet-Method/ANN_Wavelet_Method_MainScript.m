%% ANN_Wavelet_Method_MainScript

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

%% Performing Data Preparation for Wavelet-ANN Training

% User Input

FaultyData_YesNo=input('Do you want Faulty Data to be corrected [1: Yes; 0: No]: ');

WindowSize=input('Enter Window Size for sampling signals: ');

ContinuousWindow_YesNo=input('Do you want Data to be continuously windowed or not [1: Yes; 0: No]: ');

Wavelet_Level=input('Enter Level for Wavelet Decomposition: ');

Wavelet_Filter=input('Enter Wavelet Filter for Wavelet Decomposition {e.g. ''db1''}: ');

FeatureEnergySignal_YesNo=input('Do you want Average Coefficients or Energy Coefficients from Wavelet Decomposition [1: Yes; 0: No]: ');

% Calling External Function for Data Preparation

[ WSN_ANNWavelet_InputTrain_DataCell, WSN_ANNWavelet_TargetTrain_DataCell, SignalPrediction_Possibilty_YesNo ] = WSN_ANNWavelet_DataPreparation_Training( SensorDataMatrixLabelled_Cell, SensorGroup, FaultyData_YesNo, WindowSize, ContinuousWindow_YesNo, Wavelet_Level, Wavelet_Filter, FeatureEnergySignal_YesNo );

%% Training Wavelet-ANN

% User Input

Mode=input('Enter Mode [Options: 1 or 2 or 3] for Data Preparation: ');

NetType=input('Enter ANN Net Type [Options: 1 or 2 or 3]: ');

hiddenLayerSize=input('Enter the Hiddden Layer Architecture of the ANN [e.g. [5,5,5]]: ');

TrainFunc=input('Enter the Training Function to be used [e.g. ''trainlm'']: ');

TotalNets=input('Enter Toal number of ANN nets to be Trained: ');

% Calling External Function for Training the ANN

[ WSN_ANNWavelet_BestNets_Cell, WSN_ANNWavelet_FaultCriterion_VarianceValue , SignalPrediction_Possibilty_YesNo] = WSN_ANNWavelet_Training( WSN_ANNWavelet_InputTrain_DataCell, WSN_ANNWavelet_TargetTrain_DataCell, SignalPrediction_Possibilty_YesNo, NetType, hiddenLayerSize, TrainFunc, TotalNets );

%% Getting Sensor Data from Server for Prediction inside MATLAB



%% Performing Data Labelling for Faulty and Not Fauly Data

% Calling External Function for Data Labelling

[ SensorDataMatrixLabelled_Cell1, SensorTotalNum1 ] = WSN_DataLabelling_1( SensorDataMatrix1, AC_Data1, UpperBound, LowerBound, RateOfChange, SensorGroup, Res );

%% Performing Data Preparation for Wavelet-ANN Prediction

% Calling External Function for Data Preparation

[ WSN_ANNWavelet_InputPredict_DataCell, WSN_ANNWavelet_TargetPredict_DataCell, SignalPrediction_Possibilty_YesNo ] = WSN_ANNWavelet_DataPreparation_Prediction( SensorDataMatrixLabelled_Cell1, WindowSize, ContinuousWindow_YesNo, Wavelet_Level, Wavelet_Filter, FeatureEnergySignal_YesNo );

%% Predicting Using Trained Wavelet-ANN

% Calling External Function for ANN Prediction

[ Outputs_Cell, WSN_ANNWavelet_FaultDetection_Matrix ] = WSN_ANNWavelet_Prediction( WSN_ANNWavelet_InputPredict_DataCell, WSN_ANNWavelet_TargetPredict_DataCell, SignalPrediction_Possibilty_YesNo, WSN_ANNWavelet_BestNets_Cell, WSN_ANNWavelet_FaultCriterion_VarianceValue );

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

% NetType Description

% NetType==1 : fitnet Function is used
% NetType==2 : feedforwardnet Function is used
% NetType==3 : cascadeforwardnet Function is used
