%% Load Data

load sumsin;
s = sumsin;
s=s'; % Note: 
% s=s(1,1:999);

%% 1-D Wavelet Decomposition

Original_Signal=s;

Wavelet_Level=3;

Wavelet_Filter='db1';

% Daubechies
% 'db1' or 'haar', 'db2', ... ,'db10', ... , 'db45'
% Coiflets
% 'coif1', ... , 'coif5'
% Symlets
% 'sym2', ... , 'sym8', ... ,'sym45'
% Fejer-Korovkin filters
% 'fk4', 'fk6', 'fk8', 'fk14', 'fk22'
% Discrete Meyer
% 'dmey'
% Biorthogonal
% 'bior1.1', 'bior1.3', 'bior1.5'
% 'bior2.2', 'bior2.4', 'bior2.6', 'bior2.8'
% 'bior3.1', 'bior3.3', 'bior3.5', 'bior3.7'
% 'bior3.9', 'bior4.4', 'bior5.5', 'bior6.8'
% Reverse Biorthogonal
% 'rbio1.1', 'rbio1.3', 'rbio1.5'
% 'rbio2.2', 'rbio2.4', 'rbio2.6', 'rbio2.8'
% 'rbio3.1', 'rbio3.3', 'rbio3.5', 'rbio3.7'
% 'rbio3.9', 'rbio4.4', 'rbio5.5', 'rbio6.8'

[Wavelet_Coefficients,Wavelet_Coefficients_Lengths] = wavedec(Original_Signal,Wavelet_Level,Wavelet_Filter);

%% Getting the Average and Detail Coefficients of Wavelet Decomposition

% CA3=Wavelet_Coefficients(1,1:Wavelet_Coefficients_Lengths(1,1));

CA3=Wavelet_Coefficients(1:Wavelet_Coefficients_Lengths(1,1),1);

[CD1,CD2,CD3] = detcoef(Wavelet_Coefficients,Wavelet_Coefficients_Lengths,[1,2,3]);

%% Plot Original Signal
figure(1)
plot(s)
title('Original signal')

%% Plot Wavelet Signals

figure(2)
plot(CA3)
title('Level 3 Average coefficients (CA3)')

figure(3)
plot(CD3)
title('Level 3 detail coefficients (CD3)')

figure(4)
plot(CD2)
title('Level 2 detail coefficients (CD2)')

figure(5)
plot(CD1)
title('Level 1 detail coefficients (CD1)')

%% Reconstructing the Signal from Wavelet Decomposition Co-efficients

Reconstructed_Signal = waverec(Wavelet_Coefficients,Wavelet_Coefficients_Lengths,Wavelet_Filter);

%% Plotting Reconstructed Signal

figure(6)
plot(Reconstructed_Signal)
title('Reconstructed signal')