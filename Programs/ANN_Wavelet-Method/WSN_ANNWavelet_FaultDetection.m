function [ WSN_ANNWavelet_FaultDetection_Matrix ] = WSN_ANNWavelet_FaultDetection( Input_Cell, Output_Cell, FaultCriterion_VarianceValue )
%% Function Input and Output Argument Description:

% Input Arguments:

% Input_Cell : 
% Output_Cell : 
% FaultCriterion_VarianceValue : 

% Output Arguments:

% WSN_ANNWavelet_FaultDetection_Matrix :

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
  
end

% Initializing WSN_ANNWavelet_FaultDetection_Matrix

WSN_ANNWavelet_FaultDetection_Matrix=ones(C1,C2);

Diagnosis_Vector=zeros(1,C2); % Intialization

Index_Vector=zeros(1,C2); % Intialization

% Detecting Faults based on FaultCriterion_VarianceValue

for i=1:C2 % Through All Instances
    
    % Getting Variance vector
    
    Variance_Vector= Variance_Matrix(:,i);
    
    % Computing Variance Diagnosis
    
    Diagnosis=0; % Initialization
    
    Index=0; % Initialization
    
    for j=1:C1
        
       if(Variance_Vector(j,1)<=FaultCriterion_VarianceValue) 
           
           Diagnosis=Diagnosis+1;
           
           Index=j;
           
       end
        
    end
    
    Diagnosis_Vector(1,i)=Diagnosis;
    
    Index_Vector(1,i)=Index;
    
end

% Diagnosing Faults using Diagnosis_Vector and Index_Vector

for i=1:C2
    
    if (Diagnosis_Vector(1,i)==C1) % No Fault in any Sensor [1;1;1...]
        
        continue;
        
    elseif (Diagnosis_Vector(1,i)==1) % Fault in one particular Sensor [1,1,-1;1;1...]
        
        WSN_ANNWavelet_FaultDetection_Matrix(Index_Vector(1,i),i)=-1;
        
    else  % Fault cannot be decided [0;0;0;0]
        
        WSN_ANNWavelet_FaultDetection_Matrix(:,i)=zeros(C1,1);
        
    end
    
end

end

