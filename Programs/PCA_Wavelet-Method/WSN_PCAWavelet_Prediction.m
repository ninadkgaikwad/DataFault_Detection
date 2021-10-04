function [  WSN_PCAWavelet_Predicted_Matrix, WSN_PCAWavelet_Predicted_OriginalSignal_Matrix, FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCAWavelet_Prediction( WSN_PCAWavelet_Predict_Normalized_DataCell,WSN_PCAWavelet_TargetOriginal_DataCell, ReducedOrder_PCAWavelet_Matrix, ReducedOrder_PCAWavelet_Matrix_Transpose, QValue_Threshold, Training_Averages, Training_SD, Normalization_YesNo, Wavelet_Level, Wavelet_Filter  )

%% Function Input and Output Argument Description:

% Input Arguments:

% WSN_PCAWavelet_Predict_Normalized_DataCell :
% ReducedOrder_PCAWavelet_Matrix : 
% WSN_PCAWavelet_TargetOriginal_DataCell :
% ReducedOrder_PCAWavelet_Matrix_Transpose : 
% QValue_Threshold :
% Training_Averages :
% Training_SD :
% Normalization_YesNo :
% Wavelet_Level :
% Wavelet_Filter :

% Output Arguments:

% WSN_PCAWavelet_Predicted_Matrix :
% FaultDscription_Vector :
% QValue_Vector :
% QValue_Contribution_Matrix :

%% The Code

% Getting the Sizes of WSN_PCA_Predict_Normalized_DataCell and is Contained Matrices

[R1,C1]=size(WSN_PCAWavelet_Predict_Normalized_DataCell);

Container=WSN_PCAWavelet_Predict_Normalized_DataCell{1,1};

[R2,C2]=size(Container);

Container1=WSN_PCAWavelet_TargetOriginal_DataCell{1,1};

[R3,C3]=size(Container1);

% Initializing some Data Containing Matrices

DataMatrix_Instance=zeros(R2,C2);

Original_DataMatrix_Instance=zeros(R3,C3);

ErrorMatrix_Instance=zeros(R2,C2);

PredictedMatrix_NotNormalized_Instance=zeros(R2,C2);

Original_DataMatrix_Instance_Full=zeros(1,C3);

DataMatrix_Full=zeros(1,C2);

ErrorMatrix_Full=zeros(1,C2);

PredictedMatrix_NotNormalized_Full=zeros(1,C2);

% PCA Analysis for Fault Prediction

P=ReducedOrder_PCAWavelet_Matrix;

for i=1:C1 % For each Instance Matrix in WSN_PCA_Predict_Normalized_DataCell
    
    % Getting Correct instance Matrix from WSN_PCA_Predict_Normalized_DataCell
    
    DataMatrix_Instance=WSN_PCAWavelet_Predict_Normalized_DataCell{1,i};
    
    % PCA Analysis
    
    x=DataMatrix_Instance;
    
    Y=x*P; % Converting to Lower Dimension
    
    x_bar=Y*P'; % Converting to Higher Dimension
    
    error=x-x_bar; % Computing Error
    
    % Pacing Computed Values in Appropriate Matrices
    
    DataMatrix_Full=vertcat(DataMatrix_Full,DataMatrix_Instance);
    
    ErrorMatrix_Full=vertcat(ErrorMatrix_Full,error);
    
    PredictedMatrix_NotNormalized_Full=vertcat(PredictedMatrix_NotNormalized_Full,x_bar);
    
    Original_DataMatrix_Instance=WSN_PCAWavelet_TargetOriginal_DataCell{1,i};
    
    Original_DataMatrix_Full=vertcat(Original_DataMatrix_Full,Original_DataMatrix_Instance);
    
end

% Correcting for Initial Row

DataMatrix_Full=DataMatrix_Full(2:end,:);

ErrorMatrix_Full=ErrorMatrix_Full(2:end,:);

PredictedMatrix_NotNormalized_Full=PredictedMatrix_NotNormalized_Full(2:end,:);

Original_DataMatrix_Full=Original_DataMatrix_Full(2:end,:);

[r,c]=size(PredictedMatrix_NotNormalized_Full);

% Fault Detection : Using External Function

[ FaultDscription_Vector, QValue_Vector, QValue_Contribution_Matrix ] = WSN_PCAWavelet_FaultDetection( ErrorMatrix_Full, QValue_Threshold );

% Reconstructing Samples from PCA Model Estimate

WSN_PCAWavelet_Predicted_Matrix=zeros(r,c);

if (Normalization_YesNo==1) % Data was normalized hence has to be reconstructed
    
    % Correcting for Mean and Standard Deviation  
        
    for i=1:C2 % For each column in PredictedMatrix_NotNormalized_Full
        
        DataColumn=PredictedMatrix_NotNormalized_Full(:,i);
        
        DataColumn=DataColumn+Training_Averages(1,i);
        
        DataColumn=DataColumn.*Training_SD(1,i);
        
        WSN_PCAWavelet_Predicted_Matrix(:,i)=DataColumn;
        
    end
    
elseif (Normalization_YesNo==0) % Data was not normalisd hence has not to be reconstructed
    
    WSN_PCAWavelet_Predicted_Matrix=PredictedMatrix_NotNormalized_Full;
    
end

% Reconstructing Original Signal by using Inverse Wavelet Transform

% Creating Wavelet_DetailCoefficients_Marix from Original_DataMatrix_Full

[r1,c1]=size(Original_DataMatrix_Full); % Getting size of Original_DataMatrix_Full

% Getting Size for Detail_Coeffiecients_Matrix

Signal=Original_DataMatrix_Full(:,1);

[ ~, ~, Wavelet_Coefficients,Wavelet_Coefficients_Lengths ] = WSN_ANNWavelet_WavDecompose( Signal, Wavelet_Level, Wavelet_Filter );

DetailCoefficients=Wavelet_Coefficients((Wavelet_Coefficients_Lengths(1,1)+1):end,1);

[r2,c2]=size(DetailCoefficients);

Wavelet_DetailCoefficients_Matrix=zeros(r2,c1); % Initializing Wavelet_DetailCoefficients_Matrix

% Creating Wavelet_DetailCoefficients_Matrix

for i=1:c1
    
    Signal=Original_DataMatrix_Full(:,i);

    [ ~, ~, Wavelet_Coefficients,Wavelet_Coefficients_Lengths ] = WSN_ANNWavelet_WavDecompose( Signal, Wavelet_Level, Wavelet_Filter );

    DetailCoefficients1=Wavelet_Coefficients((Wavelet_Coefficients_Lengths(1,1)+1):end,1);    

    Wavelet_DetailCoefficients_Matrix(:,i)=DetailCoefficients1;
    
end

% Creating Wavelet_Coefficients_Matrix from WSN_PCAWavelet_Predicted_Matrix and Wavelet_DetailCoefficients_Matrix

Wavelet_Coefficients_Matrix=vertcat(WSN_PCAWavelet_Predicted_Matrix, Wavelet_DetailCoefficients_Matrix);

WSN_PCAWavelet_Predicted_OriginalSignal_Matrix=zeros(r1,c1); % Intializing WSN_PCAWavelet_Predicted_OriginalSignal_Matrix

for i=1:c1 % For Each Column in Wavelet_Coefficients_Matrix
    
    [ Wavelet_ReconstructedSignal_Vector ] = WSN_ANNWavelet_WavRecreate( Wavelet_Coefficients_Matrix(:,i), Wavelet_Coefficients_Lengths, Wavelet_Filter);

    WSN_PCAWavelet_Predicted_OriginalSignal_Matrix(:,i)=Wavelet_ReconstructedSignal_Vector;
    
end

end

