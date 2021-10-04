function [ WSN_ANNWavelet_FaultCriterion_VarianceValue ] = WSN_ANNWavelet_FaultCriterion_Calculation( Input_Cell, Output_Cell )
%% Function Input and Output Argument Description:

% Input Arguments:

% Input_Cell : 
% Output_Cell : 

% Output Arguments:

% WSN_ANNWavelet_FaultCriterion_VarianceValue  :

%% The Code

% Getting Size of Input Cell

[R1,C1]=size(Input_Cell);

% Getting Size of the Matrix wihin Input_Cell

[R2,C2]=size(Input_Cell{1,1});

% Initializing the Variance Matrix

Variance_Matrix=zeros(C1,C2);

% Computing Values of Variance_Matrix

for i=1:C1 % For Each Sensor
    
    InputMatrix=Input_Cell{1,i};
    
    OutputMatrix=Output_Cell{1,i};
    
   for j=1:C2 % For Each Column in the Sensor
       
       Input_Vector=InputMatrix(:,j); % Getting Vector X'
       
       Output_Vector=OutputMatrix(:,j); % Getting Vector X''
       
       Combined_Vector=vertcat(Input_Vector,Output_Vector); % Combining tHe two vectors
       
       Variance=var(Combined_Vector); % Computing Variance of the combined data series
       
       Variance_Matrix(i,j)=Variance; % Storing appropriately in Variance_Matrix
                     
   end
    
   % Plotting Variance Graphs
   
   figure(i)
   plot(Variance_Matrix(i,:));
   title('Instance-wise Variance Values for Sensor Num ',num2str(i));
   
end

% Computing Average Variance of all Sensors at each Instant

AverageVariance_Instance=mean(Variance_Matrix,1);

figure
plot(AverageVariance_Instance);
title('Instance-wise  Average Variance Values for all Sensors');

% Computing Average Variance of all Instances of Each Sensor

AverageVariance_Sensor=mean(Variance_Matrix,2);

display(AverageVariance_Sensor);

WSN_ANNWavelet_FaultCriterion_VarianceValue=input('Enter the Variance Threshold for Fault Detection: ');

end

