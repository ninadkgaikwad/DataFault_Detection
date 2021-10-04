function [ WSN_PCA_Predicted_Matrix, FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCA_Prediction(  WSN_PCA_Predict_Normalized_DataCell, ReducedOrder_PCAMatrix, ReducedOrder_PCAMatrix_Transpose, QValue_Threshold, Training_Averages, Training_SD, Normalization_YesNo )

%% Function Input and Output Argument Description:

% Input Arguments:

% WSN_PCA_Predict_Normalized_DataCell :
% ReducedOrder_PCAMatrix : 
% ReducedOrder_PCAMatrix_Transpose : 
% QValue_Threshold :
% Training_Averages :
% Training_SD :
% Normalization_YesNo :

% Output Arguments:

% WSN_PCA_Predicted_Matrix :
% FaultDscription_Vector :
% QValue_Vector :
% QValue_Contribution_Matrix :

%% The Code

% Getting the Sizes of WSN_PCA_Predict_Normalized_DataCell and is Contained Matrices

[R1,C1]=size(WSN_PCA_Predict_Normalized_DataCell);

Container=WSN_PCA_Predict_Normalized_DataCell{1,1};

[R2,C2]=size(Container);

% Initializing some Data Containing Matrices

DataMatrix_Instance=zeros(R2,C2);

ErrorMatrix_Instance=zeros(R2,C2);

PredictedMatrix_NotNormalized_Instance=zeros(R2,C2);

DataMatrix_Full=zeros(1,C2);

ErrorMatrix_Full=zeros(1,C2);

PredictedMatrix_NotNormalized_Full=zeros(1,C2);

% PCA Analysis for Fault Prediction

P=ReducedOrder_PCAMatrix;

for i=1:C1 % For each Instance Matrix in WSN_PCA_Predict_Normalized_DataCell
    
    % Getting Correct instance Matrix from WSN_PCA_Predict_Normalized_DataCell
    
    DataMatrix_Instance=WSN_PCA_Predict_Normalized_DataCell{1,i};
    
    % PCA Analysis
    
    x=DataMatrix_Instance;
    
    Y=x*P; % Converting to Lower Dimension
    
    x_bar=Y*P'; % Converting to Higher Dimension
    
    error=x-x_bar; % Computing Error
    
    % Pacing Computed Values in Appropriate Matrices
    
    DataMatrix_Full=vertcat(DataMatrix_Full,DataMatrix_Instance);
    
    ErrorMatrix_Full=vertcat(ErrorMatrix_Full,error);
    
    PredictedMatrix_NotNormalized_Full=vertcat(PredictedMatrix_NotNormalized_Full,x_bar);
    
end

% Correcting for Initial Row

DataMatrix_Full=DataMatrix_Full(2:end,:);

ErrorMatrix_Full=ErrorMatrix_Full(2:end,:);

PredictedMatrix_NotNormalized_Full=PredictedMatrix_NotNormalized_Full(2:end,:);

[r,c]=size(PredictedMatrix_NotNormalized_Full);

% Fault Detection : Using External Function

[ FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCA_FaultDetection( ErrorMatrix_Full, QValue_Threshold );

% Reconstructing Samples from PCA Model Estimate

WSN_PCA_Predicted_Matrix=zeros(r,c);

if (Normalization_YesNo==1) % Data was normalized hence has to be reconstructed
    
    % Correcting for Mean and Standard Deviation  
        
    for i=1:C2 % For each column in PredictedMatrix_NotNormalized_Full
        
        DataColumn=PredictedMatrix_NotNormalized_Full(:,i);
        
        DataColumn=DataColumn+Training_Averages(1,i);
        
        DataColumn=DataColumn.*Training_SD(1,i);
        
        WSN_PCA_Predicted_Matrix(:,i)=DataColumn;
        
    end
    
elseif (Normalization_YesNo==0) % Data was not normalisd hence has not to be reconstructed
    
    WSN_PCA_Predicted_Matrix=PredictedMatrix_NotNormalized_Full;
    
end

end