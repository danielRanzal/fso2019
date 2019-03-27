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
PROG.progressBar = true;

%% Input Parameters
% SNR_dB = 0:25;                                                          % array of SNRs to be tested [dB]
% SNR_dB = [0:9 9.1:0.1:13 14:25];                                                          % array of SNRs to be tested [dB]
SNR_dB = 9:0.2:13;                                                          % array of SNRs to be tested [dB]
pilot_scaleFactor = 0.5:0.1:1.5;

SIG.M = 16;                                                                     % QAM constellation size
SIG.symRate_net = 50e9;                                                             % total gross symbol-rate of the multi-subcarrier signal
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

%% Define DSP Parameters
applyCPE = SIG.laserLW > 0;
DSP = presetDSP_B2B_QAM_SC(TX.SIG,useAdaptEqualizer,useMEX,applyCPE);

%% Test All SNRs
nIter1 = numel(pilot_scaleFactor);
nIter2 = numel(SNR_dB);
[BER,SER,EVM,MI,GMI,NGMI,nTaps_CPE,FOM_CPE] = deal(NaN(nIter1,nIter2));
progressbar
for k = 1:nIter1
    ti1 = tic;
    fprintf('\n+++++++++++++++++++++++++++++++++++++++++++++++');
    fprintf('\nIteration number %d of %d -- scaleFactor=%1.1f',...
        k,nIter1,pilot_scaleFactor(k));
    
    PILOTS.scaleFactor = pilot_scaleFactor(k);
    
    % Get Parameters:
    [TX,RX] = presetTXparams_B2B_QAM_SC(SIG,FEC,PILOTS);
    
    % SC Transmitter:
    [S.txSC,S.tx,TX] = SC_transmitter(TX);
    DSP.PILOTS = TX.PILOTS;
    DSP.CPE1.PILOTS = DSP.PILOTS;

    for n = 1:nIter2
        ti2 = tic;
        fprintf('\n\t+++++++++++++++++++++++++++++++++++++++++++++++');
        fprintf('\n\tIteration number %d of %d -- SNR=%1.1f dB',...
            n,nIter2,SNR_dB(n));

        SNR.SNRout_dB = SNR_dB(n);

        % Set SNR:
        SNR.Pin = mean(abs(S.txSC).^2,2);
        S.rx = setSNR(S.txSC,SNR,TX.PARAM,TX.SIG);

        % ADC:
        [S.rx,~,PARAM] = Rx_ADC(S.rx,RX.ADC,TX.PARAM);

        % Rx-DSP:
        [RES,~,~,~,DSP_out] = rxDSP_SC_B2B_ideal(S.rx,S.tx,...
            PARAM,TX.SIG,TX.QAM,DSP);

        % Get Results:
        nTaps_CPE(k,n) = DSP_out.CPE1.nTaps;
        FOM_CPE(k,n) = DSP_out.CPE1.FOM_error;
        BER(n) = RES.BER.BERx;
        SER(n) = RES.SER.SERx;
        EVM(n) = RES.EVM.EVMx;
        MI(n) = RES.MI.MIx;
        GMI(n) = RES.GMI.GMIx;
        NGMI(n) = RES.GMI.NGMIx;
        fprintf('\n\tBER: %1.3e',BER(n));
        fprintf('\n\tNGMI: %1.3f',NGMI(n));

        % Update progressbar:
        progressbar(((k-1)*nIter2+n)/(nIter1*nIter2));

        % Elapsed Time:
        fprintf('\n\tElapsed Time (Iteration 2): %1.4f [s]\n',toc(ti2));
        fprintf('\t+++++++++++++++++++++++++++++++++++++++++++++++\n\n');
    end
    % Elapsed Time:
    fprintf('\nElapsed Time (Iteration 1): %1.4f [s]\n',toc(ti1));
    fprintf('+++++++++++++++++++++++++++++++++++++++++++++++\n\n');
end

%% Save Results
if saveRes
    fileName = [num2str(SIG.M) 'QAM_uniform_',...
        num2str(2*TX.SIG.bitRate_net*1e-9) 'Gbps'];
    fileName = [fileName '_' ...
        num2str((1-PILOTS.rate)*100,'%1.3f') ...
        '%-PILOTS-' PILOTS.option];
    fileName = [fileName '_laserLW=' ...
        num2str(SIG.laserLW*1e-3) 'KHz'];
    fileName = [fileName '_scaleFactorSweep'];
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
