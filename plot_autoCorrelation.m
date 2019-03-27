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
fileName = 'powerMeas_19-Mar-2019';
tMax = 3600;

%% Load Results
load(fileName);

%% Calculate Auto-Correlation
a = outPower - mean(outPower);
corr = 10*log10(abs(xcorr(a)));

%% Plot Power versus Time
figure();
hold on;

hPlot = plot(corr);
set(hPlot,'marker','none','Color',RGB.itblue,...
    'linewidth',1,'linestyle','-');

% Axis Formatting:
xlabel('Time [s]','Interpreter','latex','FontSize',13);
ylabel('Optical Power [dBm]','Interpreter','latex','FontSize',13);
xAxis = get(gca,'xaxis');
set(xAxis,'TickLabelInterpreter','latex','FontSize',14);
yAxis = get(gca,'yaxis');
set(yAxis,'TickLabelInterpreter','latex','FontSize',14);

% Gridlines:
grid on;
set(gca,'GridLineStyle','--','XMinorTick','off','XMinorGrid','off',...
    'PlotBoxAspectRatio',[1 0.5 1],'Box','on');
