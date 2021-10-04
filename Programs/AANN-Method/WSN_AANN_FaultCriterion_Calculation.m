function [ AANN_FaultCriterion ] = WSN_AANN_FaultCriterion_Calculation( Output, Input, Mode, ErrorTolerance )
%% Function Input and Output Argument Description:

% Input Arguments:

% Output : 
% Input : 
% Mode : 
% ErrorTolerance :

% Output Arguments:

% AANN_FaultCriterion :

%% The Code

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

% Finding the Maximum Error

MaxError=max(Error_Matrix);

% Computing AANN_FaultCriterion

AANN_FaultCriterion=ErrorTolerance*(MaxError);

end

