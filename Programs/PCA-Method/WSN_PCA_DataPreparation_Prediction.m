function [  WSN_PCA_Predict_Normalized_DataCell ] = WSN_PCA_DataPreparation_Prediction( SensorDataMatrixLabelled_Cell, WindowSize, ContinuousWindow_YesNo, FeatureEnergySignal_YesNo,Normalization_YesNo, Normalization_TrainPredict, Training_Averages, Training_SD)

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorDataMatrixLabelled_Cell : 
% WindowSize : 
% ContinuousWindow_YesNo : 
% Wavelet_Level : 
% Wavelet_Filter : 
% FeatureEnergySignal_YesNo :
% Normalization_YesNo :
% Normalization_TrainPredict :
% Training_Averages :
% Training_SD :

% Output Arguments:

% WSN_PCA_Predict_Normalized_DataCell :

%% Note: The availabe Wavelet Transform Filters

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

%% The Code

% Getting Size of SensorDataMatrixLabelled_Cell

[R,C]=size(SensorDataMatrixLabelled_Cell);

Sensor_TotalNumber=C/2; % Getting Total Number of Sensors

% Getting The Measurement Data and Fault Label from SensorDataMatrixLabelled_Cell

% SensorMatrix_DataLabels_Cell=cell(1,2); % Intializing the Cell

% Getting Row size of the SensorDataMatrixLabelled_Cell Contents

Contents={SensorDataMatrixLabelled_Cell(1,1)};

[R1,C1]=size(Contents);

% Initializing DataMatrix and LabelMatrix

DataMatrix=zeros(R1,Sensor_TotalNumber);

LabelMatrix=zeros(R1,Sensor_TotalNumber);

% Filling Properly the SensorMatrix_DataLabels_Cell

for i=1:Sensor_TotalNumber
    
   Sensor_DataLabel_Matrix= {SensorDataMatrixLabelled_Cell(1,i)};
   
   Sensor_Data= Sensor_DataLabel_Matrix(:,1); % The Sensor Measurement Values
   
   Sensor_Labels= Sensor_DataLabel_Matrix(:,4); % The Sensor Label Values [1]=Not Faulty, [-1]=Faulty
   
   DataMatrix(:,i)=Sensor_Data; % Placing the Sensor Data Appropriately
   
   LabelMatrix(:,i)=Sensor_Labels; % Placing the Sensor Data Labels Appropriately
    
end

% Creating Input Signal Vectors for Wavelet Transform based on WindowSize and ContinuousWindow_YesNo

[R2,C2]=size(DataMatrix);

Windowed_DataMatrix_Cell=cell(1,C2); % Initializing Cell Array

if (ContinuousWindow_YesNo==1) % Prepare Data using ContinuousWindow
    
    % Computing Sizes for Input and Target Training Datasets
    
    for j=1:C2

        FaultCorrected_WindowedVector_Matrix=zeros(WindowSize,((R2+1)-WindowSize));

            for i=1:(R2-(WindowSize-1))

                FaultCorrected_WindowedVector=FaultCorrected_DataMatrix(i:(WindowSize+(i-1)),j);

                FaultCorrected_WindowedVector_Matrix(:,i)=FaultCorrected_WindowedVector;       

            end    

        Windowed_DataMatrix_Cell(1,j)={FaultCorrected_WindowedVector_Matrix};

    end
    
elseif (ContinuousWindow_YesNo==0) %  Prepare Data not using ContinuousWindow
    
        % Computing Sizes for Input and Target Training Datasets

    b=floor(r/WindowSize); % Number of Data Vectors for Non Continius Window

    for j=1:c

        FaultCorrected_WindowedVector_Matrix=zeros(WindowSize,b);

            for i=1:b

                FaultCorrected_WindowedVector=FaultCorrected_DataMatrix((1+((i-1)*WindowSize)):(i*WindowSize),j);

                FaultCorrected_WindowedVector_Matrix(:,i)=FaultCorrected_WindowedVector;              

            end

        Windowed_DataMatrix_Cell(1,j)={FaultCorrected_WindowedVector_Matrix};

    end    
    
end

% Getting Size of Windowed_DataMatrix_Cell

[R3,C3]=size(Windowed_DataMatrix_Cell);

% Getting Dimensions for Matrix Container for Wavelet Average Coefficients

   Windowed_DataMatrix= {Windowed_DataMatrix_Cell(1,1)};
   
   Original_Signal_Test=Windowed_DataMatrix(:,1);
   
   % Getting Size of Windowed_DataMatrix
   
   [R4,C4]=size(Windowed_DataMatrix);
   
   [ ~, ~, ~,Wavelet_Coefficients_Lengths ] = WSN_ANNWavelet_WavDecompose( Original_Signal_Test, Wavelet_Level, Wavelet_Filter );

   Wavelet_AverageCoefficient_Length=Wavelet_Coefficients_Lengths (1,1); 
   
% Intializing Wavelet_AverageCoefficients_Matrix_Cell

Wavelet_AverageCoefficients_Matrix_Cell=cell(1,C3);
    
% Taking Wavelet Transform on the Windowed_DataMatrix_Cell

for j=1:C3 % For each Windowed_DataMatrix within the Cell
    
   Windowed_DataMatrix= {Windowed_DataMatrix_Cell(1,j)};
   
   % Getting Size of Windowed_DataMatrix
   
   Wavelet_AverageCoefficients_Matrix=zeros(Wavelet_AverageCoefficient_Length,C4); % Initializing Container for
    
   for i=1:C4 % For each Coulumn inside Windowed_DataMatrix
       
       % Getting Original Signal
       
       Original_Signal=Windowed_DataMatrix(:,i);
       
       % Couputing Wavelet Transform : Calling External Function
       
       [ Wavelet_AverageCoefficients_Vector ] = WSN_ANNWavelet_WavDecompose( Original_Signal, Wavelet_Level, Wavelet_Filter );
       
       % Putting Average Coefficients in Wavelet_AverageCoefficients_Matrix
       
       Wavelet_AverageCoefficients_Matrix(:,i)=Wavelet_AverageCoefficients_Vector;
       
   end
   
   % Putting Wavelet_AverageCoefficients_Matrix in Wavelet_AverageCoefficients_Matrix_Cell
   
   Wavelet_AverageCoefficients_Matrix_Cell(1,j)={Wavelet_AverageCoefficients_Matrix};
   
end

% Initializing ANN_Wavelet__AverageCoefficients_Matrix_Cell

ANN_Wavelet_Features_Matrix_Cell=cell(1,C3);

% Creating ANN_Wavelet_Features_Matrix_Cell based on FeatureEnergySignal_YesNo

if (FeatureEnergySignal_YesNo==1)
    
    % Computing Energy Feautures from Wavelet Average Coefficients
    
    for j=1:C3 % For each Wavelet_AverageCoefficients_Matrix within the Cell
        
        Wavelet_AverageCoefficients_Matrix= {Wavelet_AverageCoefficients_Matrix_Cell(1,j)};
        
        % Initializing EnergyFeautures_Matrix

        EnergyFeautures_Matrix=zeros(Wavelet_AverageCoefficient_Length,C4);        
        
       for i=1:C4 % For each Coulumn inside Wavelet_AverageCoefficients_Matrix
           
           % Getting AverageCoefficients_Vector
           
           AverageCoefficients_Vector=Wavelet_AverageCoefficients_Matrix(:,i);
           
           % Computing Energy Feature Vector
           
           EnergyFeature_Vector=OriginalSignal.*OriginalSignal;
           
           % Putting EnergyFeature_Vector in the EnergyFeautures_Matrix
           
           EnergyFeautures_Matrix(:,i)=EnergyFeature_Vector;
           
       end
       
       % Putting EnergyFeautures_Matrix in the ANN_Wavelet__Features_Matrix_Cell
        
       ANN_Wavelet_Features_Matrix_Cell(1,j)={EnergyFeautures_Matrix};
       
    end
    
    SignalPrediction_Possibilty_YesNo=0; % Signal cannot be predicted
    
elseif (FeatureEnergySignal_YesNo==0)
    
    ANN_Wavelet_Features_Matrix_Cell=Wavelet_AverageCoefficients_Matrix_Cell;
    
    SignalPrediction_Possibilty_YesNo=1; % Signal can be predicted
    
end

% Creating WSN_ANNWavelet_Target_DataCell

WSN_PCA_TargetPredict_DataCell=ANN_Wavelet_Features_Matrix_Cell;

% Getting Size of WSN_PCA_Predict_DataCell

[R5,C5]=size(WSN_PCA_TargetPredict_DataCell);

% Getting Size of Contents of WSN_PCA_Predict_DataCell

Contents=WSN_PCA_TargetPredict_DataCell{1,1};

[R6,C6]=size(Contents);

% Intializing WSN_PCA_Predict_DataCell

WSN_PCA_Predict_DataCell=cell(1,C6);

% Creating WSN_PCA_Predict_DataCell

for i=1:C6 % For Each Column in Contents Matrix
    
    % Initializing WSN_PCA_Predict_Matrix

    WSN_PCA_Predict_Matrix=zeros(R6,C5);
    
   for j=1:C5 % For Each Sensor_Data_Matrix in WSN_PCA_TargetPredict_DataCell 
       
       Data_Matrix=WSN_PCA_TargetPredict_DataCell{1,j}; % Gettig the Sensor_Data_Matrix
       
       Data_Column_Vector=Data_Matrix(:,i); % Getting the Appropriate Column from the Appropriate Matrix
      
       WSN_PCA_Predict_Matrix(:,j)=Data_Column_Vector; % Putting the Column Vector in Approptiate column location in the WSN_PCA_Predict_Matrix
       
   end
    
   % Putting the WSN_PCA_Predict_Matrix in appropriate location in the WSN_PCA_Predict_DataCell
   
   WSN_PCA_Predict_DataCell(1,i)=WSN_PCA_Predict_Matrix;
   
end

% Initializing WSN_PCAWavelet_Predict_Normalized_DataCell

WSN_PCA_Predict_Normalized_DataCell=cell(1,C6);

% Normalization of WSN_PCAWavelet_Predict_DataCell

if (Normalization_YesNo==1) % Perform Normalization
    
    if (Normalization_TrainPredict==1) % Normalization using Training Averages and Training Standard Deviations
        
        for i=1:C6 % For each Matrix in WSN_PCAWavelet_Predict_DataCell
            
            % Getting Apropriate Matrix from WSN_PCAWavelet_Predict_Normalized_DataCell
            
            AppropriateMatrix=WSN_PCA_Predict_Normalized_DataCell{1,i};
            
            % Initializing DataMatrix
            
            DataMatrix=zeros(R6,C5);
            
           for j=1:C5 % For Each column inside the Matrix
               
               Data_Column_Vector=AppropriateMatrix(:,j); % Getting the appropriate Vector from the Matrix
               
               Data_Column_Vector=Data_Column_Vector-Training_Averages(1,j); % Subtarcting each term of the Vector from the Appropriate Mean
               
               Data_Column_Vector=Data_Column_Vector./Training_SD(1,j); % Dividing each term of the Vector by the Appropriate SD
               
               DataMatrix(:,j)=Data_Column_Vector;
               
           end
           % Putting Normalized Matrix at appropriate position in the WSN_PCAWavelet_Predict_Normalized_DataCell
           
           WSN_PCA_Predict_Normalized_DataCell(1,i)={Data_Matrix};
           
        end
        
    elseif (Normalization_TrainPredict==2) % Normalization using Prediction Data Averages and Standard Deviations
        
        for i=1:C6 % For each Matrix in WSN_PCAWavelet_Predict_DataCell
            
            % Getting Apropriate Matrix from WSN_PCAWavelet_Predict_Normalized_DataCell
            
            AppropriateMatrix=WSN_PCA_Predict_Normalized_DataCell{1,i};
            
            % Initializing DataMatrix
            
            DataMatrix=zeros(R6,C5);
            
           for j=1:C5 % For Each column inside the Matrix
               
               Data_Column_Vector=AppropriateMatrix(:,j); % Getting the appropriate Vector from the Matrix
               
               Mean=mean(Data_Column_Vector); % Calculating Vector Mean
               
               SD=std(Data_Column_Vector); % Calculating Vector SD
               
               Data_Column_Vector=Data_Column_Vector-Mean; % Subtarcting each term of the Vector from the Appropriate Mean
               
               Data_Column_Vector=Data_Column_Vector./SD; % Dividing each term of the Vector by the Appropriate SD
               
               DataMatrix(:,j)=Data_Column_Vector;
               
           end
           % Putting Normalized Matrix at appropriate position in the WSN_PCAWavelet_Predict_Normalized_DataCell
           
           WSN_PCA_Predict_Normalized_DataCell(1,i)={Data_Matrix}; 
           
        end
        
    end
    
elseif (Normalization_YesNo==0) % Do not Perform Normalization
    
    WSN_PCA_Predict_Normalized_DataCell=WSN_PCA_Predict_DataCell;
    
end


end





