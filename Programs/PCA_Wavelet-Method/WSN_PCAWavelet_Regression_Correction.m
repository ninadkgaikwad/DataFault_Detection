function [ RegressionCorrected_SensorData ] = WSN_PCAWavelet_Regression_Correction( SensorGroup, SensorGroupData, SensorNum )

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorGroup : 
% SensorGroupData : 
% SensorNum :

% Output Arguments:

% RegressionCorrected_SensorData :

%% The Code



% For Sensor Group 1

if (SensorGroup==1)
    
   if (SensorNum==1)
       
       RegressionCorrected_SensorData=(-2.79)+(0.21*SensorGroupData(1,2))+(0.65*SensorGroupData(1,3))+(0.22*SensorGroupData(1,4));     
           
       
   elseif (SensorNum==2)
       
       RegressionCorrected_SensorData=(0.92)+(0.0821*SensorGroupData(1,1))+(0.59*SensorGroupData(1,3))+(0.29*SensorGroupData(1,4));       

   elseif (SensorNum==3)
       
       RegressionCorrected_SensorData=(0.91)+(0.59*SensorGroupData(1,1))+(0.12*SensorGroupData(1,2))+(0.27*SensorGroupData(1,4));       

       
   elseif (SensorNum==4)
       
       RegressionCorrected_SensorData=(0.82)+(0.27*SensorGroupData(1,1))+(0.08*SensorGroupData(1,2))+(0.62*SensorGroupData(1,3));       

       
   end
    
end

% For Sensor Group 2

% For Sensor Group 3

% For Sensor Group 4


end






