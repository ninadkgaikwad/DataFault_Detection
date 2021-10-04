function [ Inputs, Targets ] = WSN_AANN_ModeWise_DataPreparation_Prediction( Data, Mode )
%% Function Input and Output Argument Description:

% Input Arguments:

% Data : 
% Mode : 

% Output Arguments:

% Inputs :
% Targets :

%% The Code

% Getting size of Data

[R,C]=size(Data);

% Creating Inputs and Targets based on desired Mode

if (Mode==1) % All Extracted Features vs All Extracted Features
    
    Inputs=NonFaultyData_Matrix;
    
    Targets=NonFaultyData_Matrix;
    
elseif (Mode==2) % Only Measured Value
    
    Inputs=NonFaultyData_Matrix(:,6);
    
    Targets=NonFaultyData_Matrix(:,6);    
    
elseif (Mode==3) % All Extracted Features vs Measured Value
    
    Inputs=NonFaultyData_Matrix;
    
    Targets=NonFaultyData_Matrix(:,6);    
    
end

end

