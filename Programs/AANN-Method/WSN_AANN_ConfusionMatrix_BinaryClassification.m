function [ Confusion_Matrix_Values, Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy ] = WSN_AANN_ConfusionMatrix_BinaryClassification( Outputs, Targets)
%% Function Input and Output Argument Description:

% Inpu Arguments:

% Outputs : 
% Targets : 

% Output Arguments:

% Confusion_Matrix_Values :
% Confusion_Matrix_Percent :
% Rate_Matrix :
% PredictiveValue_Matrix :
% TotalAccuracy :
% TotalInaacuracy :

%% The Code

% Getting the Size of Outputs Matrix

[R, C]=size(Outputs);

% Getting the Binary Classification Class Values

True_Target1=1;

True_Target2=0;

False_Target1=0;

False_Target2=1;

% Intializing Values

TP=0; % True Positive
FP=0; % False Positive
FN=0; % False Negative
TN=0; % True Negative

% Getting Values for TP, FP, FN, TN

for i=1:R
    
   if ((Outputs(i,1)==True_Target1)&&(Targets(i,1)==True_Target1)&&(Outputs(i,2)==True_Target2)&&(Targets(i,2)==True_Target2)) % Checking for True Positive
       
       TP=TP+1;
       
   elseif ((Outputs(i,1)==False_Target1)&&(Targets(i,1)==False_Target1)&&(Outputs(i,2)==False_Target2)&&(Targets(i,2)==False_Target2)) % Checking for True Negative
       
       TN=TN+1;
       
   elseif ((Outputs(i,1)==True_Target1)&&(Targets(i,1)==False_Target1)&&(Outputs(i,2)==True_Target2)&&(Targets(i,2)==False_Target2)) % Checking for False Positive
       
       FP=FP+1;
       
   elseif ((Outputs(i,1)==False_Target1)&&(Targets(i,1)==True_Target1)&&(Outputs(i,2)==False_Target2)&&(Targets(i,2)==True_Target2))% Checking for False Negative
       
       FN=FN+1;
       
   end
    
end

% Assembling Confusion_Matrix_Values

Confusion_Matrix_Values=[TP, FP; FN, TN];

% Computing Percentages 

TP_Percent=(TP/(TP+FP+FN+TN))*(100);

FP_Percent=(FP/(TP+FP+FN+TN))*(100);

FN_Percent=(FN/(TP+FP+FN+TN))*(100);

TN_Percent=(TN/(TP+FP+FN+TN))*(100);

% Assembling Confusion_Matrix_Percent

Confusion_Matrix_Percent=[TP_Percent, FP_Percent; FN_Percent, TN_Percent];

% Computing Rates

TPR=((TP)/(TP+FN))*100;

TNR=((TN)/(TN+FP))*100;

FNR=((FN)/(TP+FN))*100;

FPR=((FP)/(TN+FP))*100;

% Assembling Rate_Matrix

Rate_Matrix=[TPR, TNR; FNR, FPR];

% Computing Predictive Values

TPPV=((TP)/(TP+FP))*100;

FPPV=((FP)/(TP+FP))*100;

TNPV=((TN)/(TN+FN))*100;

FNPV=((FN)/(TN+FN))*100;

% Assembling PredictiveValue_Matrix

PredictiveValue_Matrix=[TPPV, TNPV; FNPV, FPPV];

% Computing TotalAccuracy and TotalInAccuracy

TotalAccuracy =((TP+TN)/(TP+TN+FP+FN))*100 ;

TotalInAccuracy =((FP+FN)/(TP+TN+FP+FN))*100 ;

end


