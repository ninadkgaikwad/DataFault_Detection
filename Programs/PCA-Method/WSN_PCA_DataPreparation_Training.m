function [ WSN_PCA_CleanData_Matrix_Training ] = WSN_PCA_DataPreparation_Training( SensorDataMatrixLabelled_Cell, SensorGroup,CleanData_YesNo, FaultyData_CorrectionAlgorithm )

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorDataMatrixLabelled_Cell : 
% SensorGroup :
% CleanData_YesNo
% FaultyData_CorrectionAlgorithm : 

% Output Arguments:

% CleanData_Matrix :

%% The Code

% Getting Size of SensorDataMatrixLabelled_Cell

% [R,C]=size(SensorDataMatrixLabelled_Cell);

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

% Cleaning Data or Not Cleaning Data

if (CleanData_YesNo==1) % Clean Data
    
    if (FaultyData_CorrectionAlgorithm==1) % Correction Using Regression Relationships and Previous Values
        
        % Cleaning Data using Algorithm-1
        
        % Initializing FaultCorrected_DataMatrix

        FaultCorrected_DataMatrix=zeros(R1,Sensor_TotalNumber);

        % Initializing FaultCorrection_IndexMatrix

        FaultCorrection_IndexMatrix=zeros(R1,Sensor_TotalNumber);

        % Creating Fault Corrected Data Matrix Cell

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

                              [CorrectedData] = WSN_PCA_Regression_Correction( SensorGroup, Sensor_Data, j );

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

                              [CorrectedData] = WSN_PCA_Regression_Correction( SensorGroup, Sensor_Data, j );

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

    WSN_PCA_CleanData_Matrix_Training=FaultCorrected_DataMatrix;
        
    elseif (FaultyData_CorrectionAlgorithm==2) % Keeping only those rows which are all non-Faulty
        
        % Initializing CleanData_Matrix
        
        WSN_PCA_CleanData_Matrix_Training=zeros(1,Sensor_TotalNumber);
        
        % Cleaning Data using Algorithm-2
        
        for i=1:R1 % For each row in DataMatrix
            
            FaultLabel_Vector=find(LabelMatrix(i,:)==1); % Finding Faulty Sensor Data in the particular row
            
            FaultLabel_Vector_Length=length(FaultLabel_Vector); % Finding Number of Faulty Sensor Data in the particular row
            
            if (FaultLabel_Vector_Length==Sensor_TotalNumber) % Entire Row not Faulty Condition
                
                WSN_PCA_CleanData_Matrix_Training=vertcat(WSN_PCA_CleanData_Matrix_Training,DataMatrix(i,:)); % Retaining the Non-Faulty Data
                
            end
            
        end
        
        WSN_PCA_CleanData_Matrix_Training=WSN_PCA_CleanData_Matrix_Training(2:end,:); % Getting rid of the initializing zeros row
        
    end
    
elseif (CleanData_YesNo==0) % Do not Clean Data
    
        WSN_PCA_CleanData_Matrix_Training=DataMatrix;
    
end

        


