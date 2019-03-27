%% TITLE:   Calculate Theoretical GMI of Single-Carrier QAM for the AWGN Channel
%
%   This m-file calculates the theoretical GMI of single-carrier QAM for
%   the AWGN channel using a Monte-Carlo approach. The obtained GMI results
%   can then be saved in .mat files and integrated in the OptDSP library,
%   providing a theoretical reference for the achievable GMI in AWGN
%   channels.
%
%   Authors: Fernando Guiomar <guiomar@av.it.pt>
%   Last Update: 26/02/2019

clear;
clear global;
close all;
clc;

%% Load Libraries
addpath(genpath('..\..\..\'));

%% Initialization
initProg();
RGB = fancyColors();

%% Input Parameters
% M = [8 16 32 64];
M = [4 8 16 32 64 128 256];
modulation = 'QAM';
SNR_dB = 0:0.1:40;
nPol = 2;

%% Load MI/GMI Results
nIter = numel(SNR_dB);
[MI,GMI] = deal(NaN(numel(M),numel(SNR_dB)));
for n = 1:numel(M)
    MI(n,:) = nPol*snr2mi(SNR_dB,M(n));
    GMI(n,:) = nPol*snr2gmi(SNR_dB,M(n));
end
C = nPol*snr2shannon(SNR_dB);

%% Plot GMI versus SNR
yLim = [0 20];
xLim = [0 29];

colors = {RGB.green,RGB.itblue,RGB.itred,RGB.cyan,RGB.orange,...
    RGB.violet,RGB.pink,RGB.darkGray};

figure();
hold on;
hPlot_Shannon = plot(SNR_dB,C);
lgdString{1} = 'Shannon Capacity';
for n = 1:numel(M)
    hPlot_GMI(n) = plot(SNR_dB,GMI(n,:));
%     hPlot_MI(n) = plot(SNR_dB,MI(n,:));
    set([hPlot_GMI(n) ],'color',colors{n});
    lgdString{n+1} = [num2str(M(n)),modulation];
end

[maxGMI,idx] = max(GMI);
changePoints = find(diff(idx))+1;
% hPlot_maxGMI = plot(SNR_dB(changePoints),maxGMI(changePoints));

% Plot Formatting:
set(hPlot_Shannon,'LineStyle','-','LineWidth',1.75,...
    'Marker','none','color','k');
set(hPlot_GMI,'LineStyle','-','LineWidth',1.5,...
    'Marker','none');
% set(hPlot_maxGMI,'LineStyle','none','Marker','d',...
%     'color','k','markerfacecolor','k','markersize',6);
% set(hPlot_MI,'LineStyle','--','LineWidth',1.5,...
%     'Marker','none');

% Axes Formating:
xlabel('SNR [dB]','Interpreter','latex','FontSize',13);
ylabel('SE [bit/sym]','Interpreter','latex','FontSize',13);
set(gca,'yScale','linear');
set(gca,'yLim',yLim,'yScale','linear');
set(gca,'xLim',xLim,'xTick',xLim(1):5:xLim(end),'xMinorTick','off');
set(gca,'PlotBoxAspectRatio',[1 0.7 1],'box','on');
set(get(gca,'xAxis'),'TickLabelInterpreter','latex','FontSize',13);
set(get(gca,'yAxis'),'TickLabelInterpreter','latex','FontSize',13);

% Gridlines:
grid on;
set(gca,'GridLineStyle','--');

% Legend:
hLeg = legend(lgdString);
set(hLeg,'interpreter','latex','location','northwest');

%% Exit PROG
exitProg();
