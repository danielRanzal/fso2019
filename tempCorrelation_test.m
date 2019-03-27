clc; 
clear all;
close all;
M=64;
nSamples = 1e4;
meanSNR_dB = 20;
varSNR_dB = 0.5;
varSNR_mean = 2;


meanSNR = varSNR_mean * randn(1,nSamples) + meanSNR_dB;

% snr = varSNR_dB*randn(1,nSamples) + meanSNR_dB;


%% Define the Taps
% a = [0.1:0.1:2].^2;
nTaps = 100;
a = ones(1,nTaps)/nTaps;
% a = [a fliplr(a)];
a = a/sum(a);

%% Apply Convolution
meanSNR_corr = conv(meanSNR,a,'valid');
nSamples = length(meanSNR_corr);
% snr_corr(n) = snr(n:20+n-1)*flip(a)'

snr_corr = varSNR_dB*randn(1,nSamples) + meanSNR_corr;


%%
k = 1;
for n = 5
    for k = 1:numel(snr_corr)
        idx = k-n:k-1;
        idx = idx(idx>0);
        snr_corr_est(k) = mean(snr_corr(idx));
    end
    idx1 = ~isnan(snr_corr_est);
%     snr_corr_est = circshift(snr_corr_est,[0 1]);
%     idx2 = ~isnan(snr_corr_est);
    MSE(n) = MSE_eval(snr_corr_est(idx1),snr_corr(idx1));
    
%     snr_corr_est = movmean(snr_corr,n);
%     snr_corr_est = circshift(snr_corr_est,[0 n/2+1]);
%     MSE(k) = MSE_eval(snr_corr_est(n/2+1:end),snr_corr(n/2+1:end));
%     k = k+1;
end


%%
figure, plot(MSE);

return

%% Get BER
BER_corr = snr2ber(snr_corr,M);
% BER_corr = BER_corr(numel(a):end-numel(a));

%% Plot BER
figure, plot(BER_corr);

%% Check Auto-Correlation
figure, plot(10*log10(abs(xcorr(BER_corr-mean(BER_corr),BER_corr-mean(BER_corr)))));
%% LMS filter
%LMS model : h(n+1)=h(n)+mu*x(n)*e(n)
mu=1e-12;
N=21; %number of taps
% taps=ones(1,N);%[zeros(1,N-1) 1]; %initialization
% taps = [zeros(1,N-1) 1]; %initialization

taps = [zeros(1,(N-1)/2) 1 zeros(1,(N-1)/2)];

for i=1:(nSamples-length(taps)+1) %nSamples-length(taps)+1
    idx = i:i+N-1;
%     snr_corr_estim(i) = conv(snr(idx),taps,'valid');
    snr_corr_estim(i) = snr_corr(idx)*taps.';
    snr_err(i) = snr_corr(i)-snr_corr_estim(i);
    %update filter coefficients
%     for j=1:length(taps)
% %         taps(j)=taps(j)+mu*snr_err(i)*snr_corr_estim(i);
%         taps(j) = taps(j) + mu*snr_err(i)*snr_corr(idx(j));
%     end
    taps = taps + mu*snr_err(i)*snr_corr(idx);
    taps = taps/sum(taps);
end
n=0:(nSamples-length(taps));
BER_corr_estim = snr2ber(snr_corr_estim,M);
figure,plot(1:length(BER_corr_estim),BER_corr_estim,'k',1:length(BER_corr),BER_corr,'r');

%% Calculate Mean Square Error
MSE = MSE_eval(snr_corr_estim,snr_corr);
