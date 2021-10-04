function [ Wavelet_ReconstructedSignal_Vector ] = WSN_ANNWavelet_WavRecreate( Wavelet_Coefficients, Wavelet_Coefficients_Lengths, Wavelet_Filter)
%% Function Input and Output Argument Description:

% Input Arguments:

% Wavelet_Coefficients : 
% Wavelet_Coefficients_Lengths : 
% Wavelet_Filter : 

% Output Arguments:

% Wavelet_ReconstructedSignal_Vector :

%% The Code

Wavelet_ReconstructedSignal_Vector = waverec(Wavelet_Coefficients,Wavelet_Coefficients_Lengths,Wavelet_Filter);

end

