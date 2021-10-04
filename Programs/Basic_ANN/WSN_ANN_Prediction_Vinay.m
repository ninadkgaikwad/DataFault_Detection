function [ PredictedOutput_ANN ] = WSN_ANN_Prediction_Vinay( BestNet, ANN_SensorData_Cell )
%% Function Input and Output Argument Description:

% Input Arguments:

% BestNet : 
% ANN_SensorData_Cell : 

% Output Arguments:

% PredictedOutput :

%% The Code

% Getting Inputs and Targets for Training

Inputs=ANN_SensorData_Cell{1,1};

Targets=ANN_SensorData_Cell{1,2};

inputs = Inputs';
targets = Targets';

% Prediction using Trained Net

outputs=BestNet(inputs);

% Performance of Trained Net

figure(1), plotroc(targets,outputs)
figure(2), plotconfusion(targets,outputs)
    
% Output Argument creation    

PredicteOutput_ANN=outputs';


end

