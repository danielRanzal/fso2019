%% Title:    Plot Power over Time
%
% Author: Fernando Guiomar
% Last Update: 19/03/2019

clear;
close all;
clc;

%% M-file Initialization
addpath('.\functions\');
% Load custom colors:
RGB = fancyColors();

%% Input Parameters
fileName = 'powerMeas_20-Mar-2019';
tMax = 3600*5;
meanSNR_dB = 15;
SNR_margin_dB = 2;
symRate = 32e9;
nPol = 2;

%% Load Results
load(fileName);
% tMeas = tMeas(2:end);
% tMeas = linspace(0,tMax,numel(outPower));

%% Remove Outliers
idx = outPower > -20 & outPower < 0;
outPower = outPower(idx);
tMeas = tMeas(idx);

%% Transform Into SNR Values
SNR_dB = outPower - mean(outPower) + meanSNR_dB;

%% Downsample
dt = 10; % sampling period (s)
K = 8*dt;
% K = 1;
tMeas = tMeas(1:K:end);
SNR_dB = SNR_dB(1:K:end);

%% Track Power
for n = 1:100
    SNR_dB_est = estimate_meanSNR(SNR_dB,n);
    idx = ~isnan(SNR_dB_est);
    MSE(n) = mean((SNR_dB_est(idx)-SNR_dB(idx)).^2);
end
[~,idx] = min(MSE);
SNR_dB_est = estimate_meanSNR(SNR_dB,idx);

%% Remove Initial Transient
SNR_dB_est = SNR_dB_est(idx+1:end);
SNR_dB = SNR_dB(idx+1:end);
tMeas = tMeas(idx+1:end);

%% Determine Maximum Capacity of the Link
SNR_dB_withMargin = SNR_dB_est - SNR_margin_dB;
nGMIth = 0.9;
M_PCS = 256;
upd = textprogressbar(numel(SNR_dB_withMargin),'updatestep',1,...
    'startmsg','Evaluating Channel Capacity over Time ',...
    'endmsg','Done!','showactualnum',true);
for n = 1:numel(SNR_dB_withMargin)
    AIR(n) = snr2air_PCS(SNR_dB_withMargin(n),nGMIth,M_PCS);
    upd(n);
end
meanCapacity = mean(AIR);

%% Calculate NGMI for the Actual Channel SNR
upd = textprogressbar(numel(SNR_dB),'updatestep',10,...
    'startmsg','Evaluating NGMI for Selected Entropies ',...
    'endmsg','Done!','showactualnum',true);
for n = 1:numel(SNR_dB)
    NGMI(n) = snr2gmi_PCS(SNR_dB(n),M_PCS,AIR(n));
    upd(n);
end

%% Calculate Supported Bit-Rates
bitRate_opt = meanCapacity * symRate * nPol;
bitRate_min = min(AIR) * symRate * nPol;
bitRate_gain = bitRate_opt - bitRate_min

%% Plot Power versus Time
figure();
hold on;

hPlot = plot(tMeas,SNR_dB);
set(hPlot,'marker','none','Color',RGB.itblue,...
    'linewidth',1,'linestyle','-');

hPlot = plot(tMeas,SNR_dB_est);
set(hPlot,'marker','none','Color',RGB.itred,...
    'linewidth',1.7,'linestyle','-');

% Axis Formatting:
xlabel('Time [s]','Interpreter','latex','FontSize',13);
ylabel('SNR [dB]','Interpreter','latex','FontSize',13);
xAxis = get(gca,'xaxis');
set(xAxis,'TickLabelInterpreter','latex','FontSize',14,...
    'Limits',[0 tMax]);
yAxis = get(gca,'yaxis');
set(yAxis,'TickLabelInterpreter','latex','FontSize',14);

% Gridlines:
grid on;
set(gca,'GridLineStyle','--','XMinorTick','off','XMinorGrid','off',...
    'PlotBoxAspectRatio',[1 0.5 1],'Box','on');
