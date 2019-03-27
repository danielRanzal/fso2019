%% TITLE:   Transmitter, AWGN Channel and Receiver for Single-Carrier Uniformly Distributed QAM Signals (with SNR Sweep and Comparison Against Theory)
%
% Authors: Fernando Guiomar <guiomar@av.it.pt>
% Last Update: 07/01/2019

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
% SNR_dB = 0:25;                                                          % array of SNRs to be tested [dB]
SNR_dB = [0:9 9.1:0.1:13 14:25];                                                          % array of SNRs to be tested [dB]

SIG.symRate_net = 50e9;                                                             % total gross symbol-rate of the multi-subcarrier signal
SIG.M = 16;                                                                     % QAM constellation size
SIG.modulation = 'QAM';
SIG.rollOff = 0.05;
SIG.nPol = 1;
SIG.nSyms = 2^17;                                                               % total number of simulated symbols
SIG.laserLW = 6e5;

FEC.active = false;
FEC.rate = 5/6;

PILOTS.active = true;
PILOTS.rate = 31/32;
PILOTS.option = 'customQPSK';
PILOTS.scaleFactor = 1.1;

useAdaptEqualizer = false;                                                  % flag to indicate whether to use or not and adaptive equalizer
useMEX = true;

% SNR Parameters:
SNR.noiseSeed = 101;                                                        % fixed noise seed to guarantee the same noise is generated between different runs of this m-file, thus ensuring the same output results. Comment this line for different pseudo-random noise generation in each run

% Save Results:
baseFolder = ['C:\Users\guiomar\OneDrive - Politecnico di Torino\'...
    'projects\advMH\MATLAB\'];
fileDir = [baseFolder 'PCS_GMI_eval\results\'];
saveRes = true;

%% Get Parameters
[TX,RX] = presetTXparams_B2B_QAM_SC(SIG,FEC,PILOTS);

%% Single-Carrier Transmitter
[S.txSC,S.tx,TX] = SC_transmitter(TX);

%% Define DSP Parameters
applyCPE = SIG.laserLW > 0;
DSP = presetDSP_B2B_QAM_SC(TX.SIG,useAdaptEqualizer,useMEX,applyCPE);
DSP.PILOTS = TX.PILOTS;
if applyCPE
    DSP.CPE1.PILOTS = DSP.PILOTS;
end

%% Test All SNRs
nIter = numel(SNR_dB);
[BER,SER,EVM,MI,GMI,NGMI,nTaps_CPE,FOM_CPE] = deal(NaN(1,nIter));
for n = 1:nIter
    ti1 = tic;
    fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++');
    fprintf('\nIteration number %d of %d -- SNR=%1.1f dB',...
        n,nIter,SNR_dB(n));

    SNR.SNRout_dB = SNR_dB(n);

    % Set SNR:
    SNR.Pin = mean(abs(S.txSC).^2,2);
    S.rx = setSNR(S.txSC,SNR,TX.PARAM,TX.SIG);

    % ADC:
    [S.rx,~,PARAM] = Rx_ADC(S.rx,RX.ADC,TX.PARAM);

    % Rx-DSP:
    [RES,~,~,~,DSP_out] = rxDSP_SC_B2B_ideal(S.rx,S.tx,...
        PARAM,TX.SIG,TX.QAM,DSP);
    if applyCPE
        nTaps_CPE(n) = DSP_out.CPE1.nTaps;
        FOM_CPE(n) = DSP_out.CPE1.FOM_error;
    end
    
    % Get Results:
    BER(n) = RES.BER.BERx;
    SER(n) = RES.SER.SERx;
    EVM(n) = RES.EVM.EVMx;
    MI(n) = RES.MI.MIx;
    GMI(n) = RES.GMI.GMIx;
    NGMI(n) = RES.GMI.NGMIx;
    fprintf('\n\tBER: %1.3e',BER(n));
    fprintf('\n\tNGMI: %1.3f',NGMI(n));

    % Elapsed Time:
    fprintf('\nElapsed Time (Iteration 1): %1.4f [s]\n',toc(ti1));
    fprintf('+++++++++++++++++++++++++++++++++++++++++++++++\n\n');
end

%% Determine Theoretical BER Curves and Shannon Capacity
SNRt_dB = 0:0.1:40;
BERt = snr2ber(SNRt_dB,TX.QAM);
SERt = snr2ser(SNRt_dB,TX.QAM);
EVMt = 10.^(-SNRt_dB(n)/20)*100;
MIt = snr2mi(SNRt_dB,TX.QAM);
GMIt = snr2gmi(SNRt_dB,SIG.M);
NGMIt = GMIt/log2(SIG.M);

%% Plot BER versus SNR
yLim = [1e-5 1e-0];
xLim = [0 20];
plot_BER_vs_SNR(SNR_dB,BER,SNRt_dB,BERt,xLim,yLim);

%% Plot SER versus SNR
plot_SER_vs_SNR(SNR_dB,SER,SNRt_dB,SERt,xLim,yLim);

%% Plot EVM versus SNR
yLim = [5 100];
plot_EVM_vs_SNR(SNR_dB,EVM,SNRt_dB,EVMt,xLim,yLim);

%% Plot MI versus SNR
yLim = [0.5 log2(TX.QAM.M)+0.5];
plot_MI_vs_SNR(SNR_dB,MI,SNRt_dB,MIt,xLim,yLim);

%% Save Results
if saveRes
    fileName = [num2str(SIG.M) 'QAM_uniform_',...
        num2str(2*TX.SIG.bitRate_net*1e-9) 'Gbps'];
    if PILOTS.active
        fileName = [fileName '_' ...
            num2str((1-PILOTS.rate)*100,'%1.3f') ...
            '%-PILOTS-' PILOTS.option];
    end
    if applyCPE
        fileName = [fileName '_laserLW=' ...
            num2str(SIG.laserLW*1e-3) 'KHz'];
        if strcmp(PILOTS.option,'customQPSK')
            fileName = [fileName '_scaleFactor=' ...
                num2str(PILOTS.scaleFactor,'%1.1f')];
        end
    end
    fileName(fileName == '.') = ',';
    try
        TX.PARAM = rmfield(TX.PARAM,{'t','f'});
    end
    try
        TX.BIT = rmfield(TX.BIT,{'txBits','txSyms_afterPAS','txBits_afterPAS'});
    end
    save([fileDir fileName],'SER','EVM','MI','GMI','NGMI','SNR_dB',...
        'SERt','EVMt','MIt','GMIt','NGMIt','SNRt_dB','RX','TX',...
        'FOM_CPE','nTaps_CPE','DSP');
end

%% Exit PROG
exitProg();
