function [ ReducedOrder_PCAMatrix, ReducedOrder_PCAMatrix_Transpose, QValue_Threshold, Training_Averages, Training_SD] = WSN_PCA_Training( WSN_PCA_CleanData_Matrix_Training, Normalization_YesNo )

%% Function Input and Output Argument Description:

% Input Arguments:

% WSN_PCA_CleanData_Matrix_Training : 
% Normalization_YesNo : 

% Output Arguments:

% ReducedOrder_PCAMatrix :
% ReducedOrder_PCAMatrix_Transpose :
% QValue_Threshold :
% Training_Averages :
% Training_SD :

%% The Code

% Calculating averages and stabndard deviations of Columns of WSN_PCA_CleanData_Matrix_Training

Training_Averages=mean(WSN_PCA_CleanData_Matrix_Training);

Training_SD=std(WSN_PCA_CleanData_Matrix_Training);

% Performing Principal Component Analysis

if (Normalization_YesNo==1) % With Normalization of Data
    
    % Computing PCA
    
    [coeff,score,latent,tsquared,explained] = pca(WSN_PCA_CleanData_Matrix_Training,'Centered',true);
    
    % Normalizing the coeff
    
    Wcoeff=inv(diag(Training_SD))* coeff;
    
    PCA_Matrix=Wcoeff; % PCA Matrix : Eigen Vectors
    
    PCA_Variance=latent; % PCA Variances : Eigen Values
    
    PCA_Variance_PercentageExplanation=explained; % Percentage Variance explained by each Eigen Vector
    
    % Getting the Size of PCA_Matrix
    
    [R,C]=size(PCA_Matrix);
    
    % Creating Bar Graphs
    
    Status=C+1; % Initializing Status
    
    while (Status>C)
    
        figure(1);
        title('PCA : Eigen Values');
        xlabel('Principal Components');
        ylabel('Eigen Values');
        bar(PCA_Variance);

        figure(1);
        title('PCA : Percentage Variance Explained');
        xlabel('Principal Components');
        ylabel('Percentage Variance Explained');
        bar(PCA_Variance_PercentageExplanation); 
        
        Principal_Components=input('Enter the number odf Pricipal Componenets to be used: ');
        
        Status=Principal_Components;
        
    end
    
    % Creating the ReducedOrder_PCAMatrix and ReducedOrder_PCAMatrix_Transpsose
    
    ReducedOrder_PCAMatrix=coeff(:,Principal_Components);
    
    ReducedOrder_PCAMatrix_Transpose=ReducedOrder_PCAMatrix';
    
    % Analysis of the PCA Model
    
    x=WSN_PCA_CleanData_Matrix_Training;
    
    P=ReducedOrder_PCAMatrix;
    
    % Taking Data into Lower Dimensional Space
    
    Y=x*P;
    
    % Computing Model Estimates in Higher Dimensional Space
    
    x_bar=Y*P';
    
    % Calculating Error Matrix
    
    Error_Matrix=x-x_bar;
    
    % Q Statistic Analaysis : Calling External Function
    
elseif (Normalization_YesNo==0) % Without Normalization of Data
    
     % Computing PCA
    
    [coeff,score,latent,tsquared,explained] = pca(WSN_PCA_CleanData_Matrix_Training,'Centered',false);
       
    PCA_Matrix=coeff; % PCA Matrix : Eigen Vectors
    
    PCA_Variance=latent; % PCA Variances : Eigen Values
    
    PCA_Variance_PercentageExplanation=explained; % Percentage Variance explained by each Eigen Vector
    
    % Getting the Size of PCA_Matrix
    
    [R,C]=size(PCA_Matrix);
    
    % Creating Bar Graphs
    
    Status=C+1; % Initializing Status
    
    while (Status>C)
    
        figure(1);
        title('PCA : Eigen Values');
        xlabel('Principal Components');
        ylabel('Eigen Values');
        bar(PCA_Variance);

        figure(1);
        title('PCA : Percentage Variance Explained');
        xlabel('Principal Components');
        ylabel('Percentage Variance Explained');
        bar(PCA_Variance_PercentageExplanation); 
        
        Principal_Components=input('Enter the number odf Pricipal Componenets to be used: ');
        
        Status=Principal_Components;
        
    end
    
    % Creating the ReducedOrder_PCAMatrix and ReducedOrder_PCAMatrix_Transpsose
    
    ReducedOrder_PCAMatrix=coeff(:,Principal_Components);
    
    ReducedOrder_PCAMatrix_Transpose=ReducedOrder_PCAMatrix';    
    
    % Analysis of the PCA Model
    
    x=WSN_PCA_CleanData_Matrix_Training;
    
    P=ReducedOrder_PCAMatrix;
    
    % Taking Data into Lower Dimensional Space
    
    Y=x*P;
    
    % Computing Model Estimates in Higher Dimensional Space
    
    x_bar=Y*P';
    
    % Calculating Error Matrix
    
    Error_Matrix=x-x_bar;
    
    % Q Statistic Analaysis : Calling External Function    
    
    [ QValue_Threshold ] = WSN_PCA_FaultCriterion_Calculation( Error_Matrix );
end

end
