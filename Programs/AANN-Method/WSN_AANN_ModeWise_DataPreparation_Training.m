function [ Inputs, Targets ] = WSN_AANN_ModeWise_DataPreparation_Training( Data, Labels, Mode )
%% Function Input and Output Argument Description:

% Input Arguments:

% Data : 
% Labels : 
% Mode : 

% Output Arguments:

% Inputs :
% Targets :

%% The Code

% Getting size of Data

[R,C]=size(Data);

% Initializing Non-Faulty Data Matrix and its Counter

NonFaultyData_Matrix(1,1)=0;

Counter=0;

% Separating Non-Faulty Data from Faulty Data

for i=1:R
    
   if ((Labels(i,1)==1)&&(Labels(i,2)==0)) % Data Non-Faulty
       
       Counter=Counter+1; % Incrementing Counter
       
       NonFaultyData_Matrix(Counter,1:6)=Data(i,1:6);
       
   elseif((Labels(i,1)==0)&&(Labels(i,2)==1)) % Data Faulty
       
       continue;
       
   end
    
end

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



