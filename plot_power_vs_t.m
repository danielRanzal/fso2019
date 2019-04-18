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

%% Load Results
load(fileName);
% tMeas = tMeas(2:end);
% tMeas = linspace(0,tMax,numel(outPower));

%% Remove Outliers
idx = outPower > -20 & outPower < 0;
outPower = outPower(idx);
tMeas = tMeas(idx);

%% Downsample
dt = 60; % sampling period (s)
K = 8*dt;
% K = 1;
tMeas = tMeas(1:K:end);
outPower = outPower(1:K:end);

%% Track Power
for n = 1:100
    power_est = estimate_meanSNR(outPower,n);
    idx = ~isnan(power_est);
    MSE(n) = mean((power_est(idx)-outPower(idx)).^2);
end
[~,idx] = min(MSE);
power_est = estimate_meanSNR(outPower,idx);

%% Remove Initial Transient
power_est = power_est(idx+1:end);
outPower = outPower(idx+1:end);
tMeas = tMeas(idx+1:end);

%% Plot Power versus Time
figure();
hold on;

hPlot = plot(tMeas,outPower);
set(hPlot,'marker','none','Color',RGB.itblue,...
    'linewidth',1,'linestyle','-');

hPlot = plot(tMeas,power_est);
set(hPlot,'marker','none','Color',RGB.itred,...
    'linewidth',1.7,'linestyle','-');

% Axis Formatting:
xlabel('Time [s]','Interpreter','latex','FontSize',13);
ylabel('Optical Power [dBm]','Interpreter','latex','FontSize',13);
xAxis = get(gca,'xaxis');
set(xAxis,'TickLabelInterpreter','latex','FontSize',14,...
    'Limits',[0 tMax]);
yAxis = get(gca,'yaxis');
set(yAxis,'TickLabelInterpreter','latex','FontSize',14);

% Gridlines:
grid on;
set(gca,'GridLineStyle','--','XMinorTick','off','XMinorGrid','off',...
    'PlotBoxAspectRatio',[1 0.5 1],'Box','on');
