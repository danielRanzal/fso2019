function [DSP] = presetDSP_B2B_QAM_SC(TX,DSP_options)

% Last Update: 02/04/2019


%% Input Parser
if ~isfield(DSP_options,'useCPE1')
    DSP_options.useCPE1 = false;
end
if ~isfield(DSP_options,'useCPE2')
    DSP_options.useCPE2 = false;
end
if ~isfield(DSP_options,'useMEX')
    DSP_options.useMEX = false;
end
if ~isfield(DSP_options,'useEQ')
    DSP_options.useEQ = false;
end

%% PILOTS
usePilots = false;
if isfield(TX,'PILOTS') && TX.PILOTS.active
    DSP.PILOTS = TX.PILOTS;
    usePilots = true;
end

%% Resampling
RESAMP.nSpS = 2;

%% Matched Filtering
LPF.type = 'RRC';
LPF.rollOff = TX.SIG.rollOff;

%% Equalizer Parameters
EQ.method = 'LMS';
EQ.mex = DSP_options.useMEX;
EQ.nTaps = 51;
EQ.isReal = false;
% EQ.nBits_taps = 12;
EQ.applyPolDemux = true;
EQ.train.updateRate = 2;
EQ.train.percentageTrain = 0.3;
EQ.train.stepSize = 1e-3;
EQ.train.updateRule = 'DA';
EQ.train.DEBUG = false;
EQ.demux.updateRate = 2;
EQ.demux.stepSize = EQ.train.stepSize/2;
EQ.demux.updateRule = 'DD';
EQ.demux.DEBUG = false;
EQ.SYNC.method = 'abs';
% EQ.SYNC.debugPlots = {'xCorr'};

%% CPE1 Parameters
CPE1.method = 'pilot-based:optimized';
% CPE1.method = 'pilot-based';
CPE1.decision = 'data-aided';
% CPE1.nTaps = 15;
CPE1.nTaps_min = 1;
CPE1.nTaps_max = 101;

%% CPE2 Parameters
CPE2.method = 'DD-BPS:optimized';
% CPE2.method = 'BPS';
% CPE2.nTaps = 51;
CPE2.decision = 'DD';
CPE2.nTaps_min = 1;
CPE2.nTaps_max = 501;
CPE2.nTestPhases = 5;
CPE2.angleInterval = pi/32;
CPE2.applyUnwrap = false;
% CPE2.method = 'VV:optimized';
% CPE2.decision = 'DD';
% CPE2.QAM_classes = 'all';
% CPE2.nTaps_min = 1;
% CPE2.nTaps_max = 501;
% % CPE2.nTaps = [NaN 501];

%% Truncate Edge Samples after DSP
% TRUNC_postDSP = [1e2 1e2];
TRUNC_postDSP = [0 0];

%% DEMAPPER Parameters
DEMAPPER.use_centroids = false;
% DEMAPPER.normMethod = 'avgPower';
DEMAPPER.normMethod = 'MMSE';
% DEMAPPER.normMethod = 'minSER';
% DEMAPPER.normMethod = 'none';

%% Figures of Merit for Performance Analysis
FOM.BER.active = true;
FOM.BER.calc_BER_per_sym = false;
FOM.SER.active = true;
FOM.SER.calc_SER_per_sym = false;
FOM.EVM.active = true;
FOM.EVM.tMem = 0;
FOM.EVM.calc_EVM_per_sym = false;
FOM.MI.active = true;
FOM.GMI.active = true;
% FOM.QAM_variance.active = false;

%% Create DSP Struct
DSP.RESAMP = RESAMP;
DSP.LPF = LPF;
if DSP_options.useEQ
    DSP.EQ = EQ;
end
if DSP_options.useCPE1 && usePilots
    DSP.CPE1 = CPE1;
    DSP.CPE1.PILOTS = DSP.PILOTS;
end
if DSP_options.useCPE2
    DSP.CPE2 = CPE2;
end
DSP.TRUNC_postDSP = TRUNC_postDSP;
DSP.DEMAPPER = DEMAPPER;
DSP.FOM = FOM;

