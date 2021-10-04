function [ AANN_FaultLabel_Matrix1,AANN_FaultLabel_Matrix2] = WSN_AANN_FaultDetection( Inputs, Outputs, Mode, AANN_FaultCriterion )
%% Function Input and Output Argument Description:

% Input Arguments:

% Inputs : 
% Outputs : 
% Mode : 
% AANN_FaultCriterion :

% Output Arguments:

% AANN_FaultLabel_Matrix1 :
% AANN_FaultLabel_Matrix2 :

%% The Code

% Getting Inputs and Outputs in proper form

Input=Inputs';

Output=Outputs';

% Mode Wise Measured Value Separation from Output and Input Matrices

if (Mode==1) % All Extracted Features vs All Extracted Features
    
    MeasuredValue_Input=Input(:,6);
    
    MeasuredValue_Output=Output(:,6);
    
elseif (Mode==2) % Only Measured Value
    
    MeasuredValue_Input=Input;
    
    MeasuredValue_Output=Output;    
    
elseif (Mode==3) % All Extracted Features vs Measured Value
    
    MeasuredValue_Input=Input(:,6);
    
    MeasuredValue_Output=Output;    
    
end

% Computing Error Matrix

Error_Matrix=abs(MeasuredValue_Input-MeasuredValue_Output);

% Getting Size of Error Matrix

[R,C]=size(Error_Matrix);

% Initializing FaultLabel_Matrix

AANN_FaultLabel_Matrix1=zeros(R,2);

AANN_FaultLabel_Matrix2=zeros(R,1);

% Labelling Data Non-Faulty [1,0] and Faulty [0,1] as per Fault Criterion

for i=1:R
    
    if (Error_Matrix(i,1)<=AANN_FaultCriterion) % Data Not Faulty
        
        AANN_FaultLabel_Matrix1(i,1:2)=[1,0];
        
        AANN_FaultLabel_Matrix2(i,1)=[1];
        
    elseif (Error_Matrix(i,1)>AANN_FaultCriterion) % Data Faulty
        
        AANN_FaultLabel_Matrix1(i,1:2)=[0,1];
        
        AANN_FaultLabel_Matrix2(i,1)=[-1];
        
    end
    
end

end

