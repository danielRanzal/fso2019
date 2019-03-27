%% TITLE:   Transmitter, AWGN Channel and Receiver for Single-Carrier Uniformly Distributed QAM Signals
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
PROG.showMessagesLevel = 2;

%% Input Parameters
symRate = 32e9;                                                             % total gross symbol-rate of the multi-subcarrier signal
M = 64;                                                                     % QAM constellation size
modulation = 'QAM';
nPol = 1;
nSyms = 2^17;                                                               % total number of simulated symbols
noiseType = 'AWGN';                                                         % type of noise to be added to he signal. It can be either AWGN or colored noise. For colored noise the user has to specify a filter profile to shape the noise
% noiseType = 'colored';
useAdaptEqualizer = false;                                                  % flag to indicate whether to use or not and adaptive equalizer
useMEX = true;

% SNR Parameters:
SNR.SNRout_dB = 10;
% SNR.SNRout_dB = ber2snr(1e-2,M,'QAM');
SNR.noiseSeed = 101;                                                        % fixed noise seed to guarantee the same noise is generated between different runs of this m-file, thus ensuring the same output results. Comment this line for different pseudo-random noise generation in each run

%% Get Parameters
[TX,RX] = presetTXparams_B2B_QAM_SC(M,modulation,symRate,nSyms,nPol);

%% Single-Carrier Transmitter
[S.txSC,S.tx,TX] = SC_transmitter(TX);

%% Define DSP Parameters
DSP = presetDSP_B2B_QAM_SC(TX.SIG,useAdaptEqualizer,useMEX);

%% Set SNR
if strcmpi(noiseType,'AWGN')
%     SNR.Pin = mean(abs(S.txSC).^2,2);
    [S.rx,Pn_Fs] = setSNR(S.txSC,SNR,TX.PARAM,TX.SIG);
elseif strcmpi(noiseType,'colored')
    LPF.type = 'user-defined';
    LPF.f = [-32 -20 -15 -10 -6 -5 -4 -2]*1e9;
    LPF.f = [LPF.f 0 -fliplr(LPF.f)];
    LPF.TF_dB = [-3 -2.8 -2.5 -2.1 -1.2 -0.5 -0.1 0];
    LPF.TF_dB = [LPF.TF_dB 0 fliplr(LPF.TF_dB)];
    S.rx = setSNR(S.txSC,SNR,TX.PARAM,TX.SIG,LPF);
end

%% ADC
[S.rx,~,PARAM] = Rx_ADC(S.rx,RX.ADC,TX.PARAM);

%% Rx-DSP
[RES,S.rxFinal,SIG,PARAM_SC,DSP] = rxDSP_SC_B2B_ideal(S.rx,S.tx,PARAM,...
    TX.SIG,TX.QAM,DSP);

%% AWGN Theory
BERt = snr2ber(SNR.SNRout_dB,TX.QAM);
SERt = snr2ser(SNR.SNRout_dB,TX.QAM);
EVMt = 10^(-SNR.SNRout_dB/20)*100;
MIt = snr2mi(SNR.SNRout_dB,TX.QAM);

%% Estimate SNR From Spectrum
Fs = TX.PARAM.sampRate;
Sf = pwelch(S.rx(1,:),1e3,[],[],Fs,'centered','psd').';
[SNR_rx_dB,Ps,Pn] = SNR_estimateFromSpectrum(Sf,Fs,TX.SIG.symRate,...
    TX.SIG.rollOff,[-1 -0.9; 0.9 1],0,true);

%% Print Results
entranceMsg('RESULTS');
fprintf('\nTheoretical SER: %1.3e',SERt);
fprintf('\nSimulated SER: %1.3e\n',RES.SER.SERx);
fprintf('\nTheoretical BER: %1.3e',BERt);
fprintf('\nSimulated BER: %1.3e\n',RES.BER.BERx);
fprintf('\nTheoretical EVM: %1.3f%',EVMt);
fprintf('\nSimulated EVM: %1.3f%',RES.EVM.EVMx);
fprintf('\n\nTheoretical MI: %1.3f',MIt);
fprintf('\nSimulated MI: %1.3f\n',RES.MI.MIx);
fprintf('\nSimulated GMI: %1.3f\n',RES.GMI.GMIx);

%% Plot Constellations
scatterPlot(S.rxFinal,'res',RES,'const',DSP.DEMAPPER.C);

%% Exit PROG
exitProg();

