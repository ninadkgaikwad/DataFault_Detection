function [ Trained_SVM, SVM_Performance_Cell ] = WSN_SVM_Training_Vinay( SVM_SensorData_Cell, KernelFunction,PolyOrder )
%% Function Input and Output Argument Description:

% Input Arguments:

% SVM_SensorData_Cell : 
% KernelFunction : 

% Output Arguments:

% Trained_SVM :
% SVM_Performance_Cell :

%% The Code

% Getting Inputs and Targets for Training

Inputs=SVM_SensorData_Cell{1,1};

Targets=SVM_SensorData_Cell{1,2};

inputs = Inputs;
targets = Targets;

% Training SVM

if (KernelFunction==1) % Linear
    
    SVM = fitcsvm(data3,theclass,'KernelFunction','linear',...
    'BoxConstraint',Inf,'ClassNames',[-1,1]);
    
elseif (KernelFunction==2) % Radial Bias
    
    SVM = fitcsvm(data3,theclass,'KernelFunction','rbf',...
    'BoxConstraint',Inf,'ClassNames',[-1,1]);
    
elseif (KernelFunction==3) % Polynomial
    
    PolyOrder=input('Enter polynomial order for SVM Kernel Function: ');
    
    SVM = fitcsvm(data3,theclass,'KernelFunction','polynomial','PolynomialOrder',PolyOrder,...
    'BoxConstraint',Inf,'ClassNames',[-1,1]);
    
end

% Performance of SVM : Calling External Function

[ Confusion_Matrix_Values, Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy ] = WSN_ConfunsionMatrix_BinaryClassification( Outputs, Targets, Target_Vector )

SVM_Performance_Cell={Confusion_Matrix_Values,Confusion_Matrix_Percent, Rate_Matrix, PredictiveValue_Matrix, TotalAccuracy, TotalInAccuracy};


% Creating Output Argument

Trained_SVM=SVM;

end

