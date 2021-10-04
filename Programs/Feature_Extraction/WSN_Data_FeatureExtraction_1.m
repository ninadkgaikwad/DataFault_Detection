function [ ExtractedFeatureMatrix, ANN_SensorData_Cell, SVM_SensorData_Cell] = WSN_Data_FeatureExtraction_1( SensorDataLabelledMatrix, WindowSize, Res )

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorDataLabelledMatrix : 
% WindowSize : 
% Res : 

% Output Arguments:

% ExtractedFeatureMatrix :
% ANN_SensorData_Cell :
% SVM_SensorData_Cell :

%% The Code

% Getting Size of SensorDataLabelledMatrix

[R,C]=size(SensorDataLabelledMatrix);

% Initializing Output Arguments

ExtractedFeatureMatrix=zeros((R-(WindowSize-1)),6);

ANN_Sensor_Input=zeros((R-(WindowSize-1)),6);

ANN_Sensor_Target=zeros((R-(WindowSize-1)),2);

SVM_Sensor_Input=zeros((R-(WindowSize-1)),6);

SVM_Sensor_Target=zeros((R-(WindowSize-1)),1);

% Inilializing ANN and SVM Targets

ANN_Sensor_Target=SensorDataLabelledMatrix((WindowSize):end,2:3);

SVM_Sensor_Target=SensorDataLabelledMatrix((WindowSize):end,4);

% Extracting Features [Mean (M), Standard Deviation (SD), SNR (SNR), Maximum Deviation (MD), Velocity (V), Measurement Value (MV)]

for i=1:(R-(WindowSize-1))
    
    % Getting the Measurement Windoe from the SensorDataLabelledMatrix
    
    MeasurementWindow=SensorDataLabelledMatrix(i:(WindowSize+(i-1)),1);
    
    % Computing Mean (M)
    
    Sum=0;
    
    for j=1:WindowSize
        
       Sum=Sum+MeasurementWindow(j,1);
                     
    end    
    
    M=(1/WindowSize)*Sum;
    
    % Computing Standard Deviation (SD)
    
    Sum=0;
    
    for j=1:WindowSize
        
       Sum=Sum+(MeasurementWindow(j,1)-M)^(2);
                     
    end
    
    SD=(1/WindowSize)*(sqrt(Sum));
    
    % Computing Signal To Noise Ratio (SNR)
    
    SNR=M/SD;
    
    % Computing Maximum Deviation (MD)
    
    MD_Vector=zeros(1, WindowSize);
    
    for j=1:WindowSize
       
        MD_Vector(1,j)=MeasurementWindow(j,1)-M;
        
    end
    
    MD=max(MD_Vector);
    
    % Computing Velocity (V)
    
    V=(MeasurementWindow(WindowSize,1)-MeasurementWindow((WindowSize-1),1))/Res;
    
    % The Measurement Value (MV)
    
    MV=MeasurementWindow(WindowSize,1);
    
    % Assembling the ExtractedFeature_Vector
    
    ExtractedFeature_Vector=[M,SD,SNR,MD,V,MV];
    
    % Updating the ExtractedFeatureMatrix
    
    ExtractedFeatureMatrix(i,:)=ExtractedFeature_Vector;
    
end

% Updating ANN_Sensor_Input and SVM_Sensor_Input

ANN_Sensor_Input=ExtractedFeatureMatrix;

SVM_Sensor_Input=ExtractedFeatureMatrix;

% Creating ANN and SVM Cell Arrays

ANN_SensorData_Cell={ANN_Sensor_Input, ANN_Sensor_Target};

SVM_SensorData_Cell={SVM_Sensor_Input,SVM_Sensor_Target};
   
end

