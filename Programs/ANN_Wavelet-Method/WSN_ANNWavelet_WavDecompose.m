function [ Wavelet_AverageCoefficients_Vector, Wavelet_DetailCoefficients_Matrix, Wavelet_Coefficients,Wavelet_Coefficients_Lengths ] = WSN_ANNWavelet_WavDecompose( Original_Signal, Wavelet_Level, Wavelet_Filter )
%% Function Input and Output Argument Description:

% Input Arguments:

% Original_Signal : 
% Wavelet_Level : 
% Wavelet_Filter : 

% Output Arguments:

% Wavelet_AverageCoefficients_Vector :
% Wavelet_DetailCoefficients_Matrix  :
% Wavelet_Coefficients :
% Wavelet_Coefficients_Lengths :

%% The Code

% The Wavelet Decomposition of incoming Original Signal

[Wavelet_Coefficients,Wavelet_Coefficients_Lengths] = wavedec(Original_Signal,Wavelet_Level,Wavelet_Filter);

% Getting the Wavelet Average Coefficients

Wavelet_AverageCoefficients_Vector=Wavelet_Coefficients(1:Wavelet_Coefficients_Lengths(1,1),1);

% Getting the Wavelet Detail Coefficients

Wavelet_DetailCoefficients_Number=Wavelet_Level;

Wavelet_DetailCoefficients_Number1=1:Wavelet_DetailCoefficients_Number;

Wavelet_DetailCoefficients_Matrix=cell(1,Wavelet_DetailCoefficients_Number); % Initializing Cell Array for storing Wavelet Detail Coefficients

for i=1:Wavelet_DetailCoefficients_Number
    
    Wavelet_DetailCoefficients_Matrix(1,i)={detcoef(Wavelet_Coefficients,Wavelet_Coefficients_Lengths,Wavelet_DetailCoefficients_Number1(1,i))};
    
end

end

