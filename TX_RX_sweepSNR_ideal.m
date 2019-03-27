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
global PROG;
initProg();
PROG.showMessagesLevel = -1;

%% Input Parameters
SNR_dB = 0:0.1:35;                                                            % array of SNRs to be tested [dB]

symRate = 60e9;                                                             % total gross symbol-rate of the multi-subcarrier signal
M = 64;                                                                     % QAM constellation size
modulation = 'QAM';
nPol = 1;
nSyms = 2^18;                                                               % total number of simulated symbols

saveFlag = true;
saveFolder = '..\..\..\TOOLS\performanceMetrics\snr2gmi\';

%% Get Parameters
[TX,RX] = presetTXparams_B2B_QAM_SC(M,modulation,symRate,nSyms,nPol);

%% Single-Carrier Transmitter
[S.txSC,S.tx,TX] = SC_transmitter(TX);

%% Define DSP Parameters
DSP = presetDSP_B2B_QAM_SC(TX.SIG,false,false);
DSP = rmfield(DSP,'FOM');
DSP.FOM.GMI.active = true;

%% Test All SNRs
nIter = numel(SNR_dB);
GMI = NaN(1,nIter);
for n = 1:nIter
    ti1 = tic;
    fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++');
    fprintf('\nIteration number %d of %d -- SNR=%1.1f dB',...
        n,nIter,SNR_dB(n));

    SNR.SNRout_dB = SNR_dB(n);

    % Set SNR:
    SNR.Pin = mean(abs(S.txSC).^2,2);
    S.rx = setSNR(S.txSC,SNR,TX.PARAM,TX.SIG);

    % Rx-DSP:
    [RES] = rxDSP_SC_B2B_ideal(S.rx,S.tx,TX.PARAM,TX.SIG,TX.QAM,DSP);
    
    % Get Results:
    GMI(n) = RES.GMI.GMIx;
    fprintf('\n\tGMI: %1.3f',GMI(n));

    % Elapsed Time:
    fprintf('\nElapsed Time (Iteration 1): %1.4f [s]\n',toc(ti1));
    fprintf('+++++++++++++++++++++++++++++++++++++++++++++++\n\n');
end

%% Plot GMI versus SNR
yLim = [0.5 log2(TX.QAM.M)+0.5];
xLim = [min(SNR_dB) max(SNR_dB)];

figure();
RGB = fancyColors();
hold on;
hPlot = plot(SNR_dB,GMI);

% Plot Formatting:
set(hPlot,'Color',RGB.itred,'LineStyle','-','LineWidth',1.75,...
    'Marker','o','MarkerSize',8,'MarkerFaceColor','w');

% Axes Formating:
xlabel('SNR [dB]','Interpreter','latex','FontSize',13);
ylabel('GMI','Interpreter','latex','FontSize',13);
set(gca,'yScale','linear');
set(gca,'yLim',yLim,'yScale','linear');
set(gca,'xLim',xLim,'xTick',xLim(1):2:xLim(end),'xMinorTick','off');
set(gca,'PlotBoxAspectRatio',[1 0.9 1],'box','on');
set(get(gca,'xAxis'),'TickLabelInterpreter','latex','FontSize',13);
set(get(gca,'yAxis'),'TickLabelInterpreter','latex','FontSize',13);

% Gridlines:
grid on;
set(gca,'GridLineStyle','--');

%% Save GMI Results
fileName = [num2str(M),modulation,'_snr2gmi'];
if saveFlag
    save([saveFolder fileName],'SNR_dB','GMI');
end

%% Exit PROG
exitProg();
