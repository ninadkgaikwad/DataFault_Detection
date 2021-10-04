function [ WSN_ANNWavelet_Input_DataCell, WSN_ANNWavelet_Target_DataCell, SignalPrediction_Possibilty_YesNo ] = WSN_ANNWavelet_DataPreparation( SensorDataMatrixLabelled_Cell, SensorGroup, FaultyData_YesNo, WindowSize, ContinuousWindow_YesNo, Wavelet_Level, Wavelet_Filter, FeatureEnergySignal_YesNo )
%% Function Input and Output Argument Description:

% Input Arguments:

% SensorDataMatrixLabelled_Cell : 
% SensorGroup :
% FaultyData_YesNo : 
% WindowSize : 
% ContinuousWindow_YesNo : 
% Wavelet_Level : 
% Wavelet_Filter : 
% FeatureEnergySignal_YesNo :

% Output Arguments:

% WSN_ANNWavelet_Input_DataCell :
% WSN_ANNWavelet_Target_DataCell :
% SignalPrediction_Possibilty_YesNo :

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

SensorMatrix_DataLabels_Cell=cell(1,2); % Intializing the Cell

% Getting Row size of the SensorDataMatrixLabelled_Cell Contents

Contents={SensorDataMatrixLabelled_Cell(1,1)};

[R1,C1]=size(Contents);

% Initializing DataMatrix and LabelMatrix

DataMatrix=zeros(R1,Sensor_TotalNumber);

LabelMatrix=zeros(R1,Sensor_TotalNumber);

% Filling Properly the SensorMatrix_DataLabels_Cell

for i=1:Sensor_TotalNumber
    
   Sensor_DataLabel_Matrix= {SensorMatrix_DataLabels_Cell(1,i)};
   
   Sensor_Data= Sensor_DataLabel_Matrix(:,1); % The Sensor Measurement Values
   
   Sensor_Labels= Sensor_DataLabel_Matrix(:,4); % The Sensor Label Values [1]=Not Faulty, [-1]=Faulty
   
   DataMatrix(:,i)=Sensor_Data; % Placing the Sensor Data Appropriately
   
   LabelMatrix(:,i)=Sensor_Labels; % Placing the Sensor Data Labels Appropriately
    
end

% Initializing FaultCorrected_DataMatrix

FaultCorrected_DataMatrix=zeros(R1,Sensor_TotalNumber);

% Initializing FaultCorrection_IndexMatrix

FaultCorrection_IndexMatrix=zeros(R1,Sensor_TotalNumber);

% Creating Fault Corrected Data Matrix Cell

if (FaultyData_YesNo==1) % Correct Faulty Data Before Training
    
    for j=1:Sensor_TotalNumber % For Each Sensor Data Column
        
        for i=1:R1 % For each Measurment of the particular Sensor Data Column 
            
              if (LabelMatrix(i,j)==-1) % Data is Faulty
                  
                  if (i==1) % For First Element: As it does not have a Previous Value to Bank upon
                      
                      FaultLabels=LabelMatrix(i,:);
                      
                      FaultyLabel_Index=find(FaultLabels<0);
                      
                      FaultyLabel_Length=length(FaultyLabel_Index);
                      
                      Sensor_Data=DataMatrix(i,:);
                      
                      if (FaultyLabel_Length>1) % Other one or more Sensors are Faulty
                          
                          FaultCorrected_DataMatrix(i,j)= DataMatrix(i,j);
                          
                          FaultCorrection_IndexMatrix(i,j)=-1; % [-1] Correction Required But could not correct
                          
                      elseif (FaultyLabel_Length==1) % All other Sensors are not Faulty
                          
                          % Getting Corrected Data : Calling External Function                          
                          
                          [CorrectedData] = WSN_ANNWavelet_Regression_Correction( SensorGroup, Sensor_Data, j );
                          
                          FaultCorrected_DataMatrix(i,j)= CorrectedData;
                          
                          FaultCorrection_IndexMatrix(i,j)=1; % [1] Correction Required and Corrected
                          
                      end                      
                      
                  elseif (i>1) % For all other ELements: As they have a Previous Value to Bank upon
                      
                      FaultLabels=LabelMatrix(i,:);
                      
                      FaultyLabel_Index=find(FaultLabels<0);
                      
                      FaultyLabel_Length=length(FaultyLabel_Index);
                      
                      Sensor_Data=DataMatrix(i,:);
                      
                      if (FaultyLabel_Length>1) % Other one or more Sensors are Faulty                          
                          
                          if ((FaultCorrection_IndexMatrix(i-1,j)==1)||((FaultCorrection_IndexMatrix(i-1,j)==0)))
                              
                              FaultCorrected_DataMatrix(i,j)= FaultCorrected_DataMatrix(i-1,j);
                              
                              FaultCorrection_IndexMatrix(i,j)=1; % [1] Correction Required and Corrected
                              
                          elseif ((FaultCorrection_IndexMatrix(i-1,j)==-1))
                              
                              FaultCorrected_DataMatrix(i,j)= DataMatrix(i,j);
                              
                              FaultCorrection_IndexMatrix(i,j)=-1; % [-1] Correction Required But could not correct
                              
                          end                          
                                                  
                      elseif (FaultyLabel_Length==1) % All other Sensors are not Faulty
                          
                          % Getting Corrected Data : Calling External Function  
                          
                          [CorrectedData] = WSN_ANNWavelet_Regression_Correction( SensorGroup, Sensor_Data, j );
                          
                          FaultCorrected_DataMatrix(i,j)= CorrectedData;
                          
                          FaultCorrection_IndexMatrix(i,j)=1; % [1] Correction Required and Corrected
                          
                      end                      
                      
                  end
                  
              elseif (LabelMatrix(i,j)==1) % Data is Not Faulty
                  
                  FaultCorrected_DataMatrix(i,j)= DataMatrix(i,j);
                  
                  FaultCorrection_IndexMatrix(i,j)=0; % [0] No Correction Required
                  
              end
                        
        end
        
    end
    
elseif(FaultyData_YesNo==0) % Do not correct Faulty Data before Training
    
    FaultCorrected_DataMatrix=DataMatrix;  
    
end

% Creating Input Signal Vectors for Wavelet Transform based on WindowSize and % and ContinuousWindow_YesNo

[R2,C2]=size(FaultCorrected_DataMatrix);

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

% Creating WSN_ANNWavelet_Input_DataCell and WSN_ANNWavelet_Target_DataCell

% Creating WSN_ANNWavelet_Target_DataCell

WSN_ANNWavelet_Target_DataCell=ANN_Wavelet_Features_Matrix_Cell;

% Intializing WSN_ANNWavelet_Input_DataCell

WSN_ANNWavelet_Input_DataCell=cell(1,C3);

% Creating WSN_ANNWavelet_Input_DataCell

if (C3==1) % Only one Sensor in Group
    
    WSN_ANNWavelet_Input_DataCell= ANN_Wavelet_Features_Matrix_Cell;  
    
elseif (C3>1) % There are more than one Sensors in the group
    
    % Getting The Size of WSN_ANNWavelet_Input_DataMatrix
    
    Row=(C3-1)*Wavelet_Coefficients_Lengths;
    
    Col=C4;
    
    % Creating the WSN_ANNWavelet_Input_DataMatrix
    
    for j=1:C3
        
        WSN_ANNWavelet_Input_DataMatrix=zeros(Row,Col); % Intializing WSN_ANNWavelet_Input_DataMatrix
        
        Counter=0; % Initializing Counter
        
       for i=1:C3
           
          if (j==i)
              
              continue;
              
          else
              
              Input_Data={ANN_Wavelet_Features_Matrix_Cell(1,i)}; % Getting Appropriate Feature Matrix
              
              Counter=Counter+1; % Incrementing the Counter
              
              WSN_ANNWavelet_Input_DataMatrix((1+((Counter-1)*Wavelet_Coefficients_Lengths)):(Counter*Wavelet_Coefficients_Lengths),:)=Input_Data; % Placing Feature Matrix in Appropriate Position             
                            
          end
          
          % Creating WSN_ANNWavelet_Input_DataCell
           
          WSN_ANNWavelet_Input_DataCell(1,j)={WSN_ANNWavelet_Input_DataMatrix};
          
       end
        
    end
    
    
end

end


