function [ RegressionViolation ] = WSN_Regression_FaultLabelling_1( SensorGroup, SensorGroupData, SensorNum )

%% Function Input and Output Argument Description:

% Input Arguments:

% SensorGroup : 
% SensorGroupData : 
% SensorNum :

% Output Arguments:

% RegressionViolation :

%% The Code

% Define Absolute Value of Accepted Regression Error as per sensor system

AcceptedRegressionError=[];

% For Sensor Group 1

if (SensorGroupData==1)
    
   if (SensorNum==1)
       
       ReVal=(-2.79)+(0.21*SensorGroupData(1,2))+(0.65*SensorGroupData(1,3))+(0.22*SensorGroupData(1,4));
       
       Diff=abs(ReVal-SensorGroupData(1,1));
       
       if (Diff>AcceptedRegressionError)
           
           RegressionViolation=1;
           
       else
           
           RegressionViolation=0;
           
       end
       
   elseif (SensorNum==2)
       
       ReVal=(0.92)+(0.0821*SensorGroupData(1,1))+(0.59*SensorGroupData(1,3))+(0.29*SensorGroupData(1,4));
       
       Diff=abs(ReVal-SensorGroupData(1,1));
       
       if (Diff>AcceptedRegressionError)
           
           RegressionViolation=1;
           
       else
           
           RegressionViolation=0;
           
       end       
       
   elseif (SensorNum==3)
       
       ReVal=(0.91)+(0.59*SensorGroupData(1,1))+(0.12*SensorGroupData(1,2))+(0.27*SensorGroupData(1,4));
       
       Diff=abs(ReVal-SensorGroupData(1,1));
       
       if (Diff>AcceptedRegressionError)
           
           RegressionViolation=1;
           
       else
           
           RegressionViolation=0;
           
       end       
       
   elseif (SensorNum==4)
       
       ReVal=(0.82)+(0.27*SensorGroupData(1,1))+(0.08*SensorGroupData(1,2))+(0.62*SensorGroupData(1,3));
       
       Diff=abs(ReVal-SensorGroupData(1,1));
       
       if (Diff>AcceptedRegressionError)
           
           RegressionViolation=1;
           
       else
           
           RegressionViolation=0;
           
       end       
       
   end
    
end

% For Sensor Group 2

% For Sensor Group 3

% For Sensor Group 4


end

