function [DSP] = presetDSP_B2B_QAM_SC(SIG,useEQ,useMEX,useCPE)

% Last Update: 04/12/2018


%% Input Parser
if ~exist('useCPE','var')
    useCPE = false;
end

%% Resampling
RESAMP.nSpS = 2;

%% Matched Filtering
LPF.type = 'RRC';
LPF.rollOff  = SIG.rollOff;

%% Equalizer Parameters
EQ.method = 'LMS';
EQ.mex = useMEX;
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

%% CPE Parameters
CPE1.method = 'pilot-based:optimized';
CPE1.decision = 'data-aided';
% CPE1.nTaps = 15;
CPE1.nTaps_min = 1;
CPE1.nTaps_max = 101;

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
FOM.BER.saveErrPos = true;
FOM.BER.calc_BER_per_sym = false;
FOM.SER.active = true;
FOM.SER.calc_SER_per_sym = false;
FOM.EVM.active = true;
FOM.EVM.tMem = 0;
FOM.EVM.normMethod = 'MMSE';
FOM.EVM.use_centroids = false;
FOM.EVM.calc_EVM_per_sym = true;
FOM.MI.active = true;
FOM.MI.normMethod = 'MMSE';
FOM.MI.use_centroids = false;
FOM.MI.debug = false;
FOM.GMI.active = true;
% FOM.QAM_variance.active = false;

%% Create DSP Struct
DSP.RESAMP = RESAMP;
DSP.LPF = LPF;
if useEQ
    DSP.EQ = EQ;
end
if useCPE
    DSP.CPE1 = CPE1;
end
DSP.TRUNC_postDSP = TRUNC_postDSP;
DSP.DEMAPPER = DEMAPPER;
DSP.FOM = FOM;

