function [TX,RX] = presetTXparams_B2B_QAM_SC(SIG,FEC,PILOTS)

% Last Update: 26/03/2019


%% Input Parser
if ~PILOTS.active
    PILOTS.rate = 1;
end

%% Simulation and Signal Parameters
Rs_gross = SIG.symRate_net / FEC.rate / PILOTS.rate;
TX.SIG = setSignalParams('symRate',Rs_gross,'M',SIG.M,...
    'nPol',SIG.nPol,'nBpS',log2(SIG.M),'nSyms',SIG.nSyms,...
    'roll-off',SIG.rollOff,'modulation',SIG.modulation);
TX.SIG.bitRate_net = TX.SIG.bitRate * FEC.rate * PILOTS.rate;
TX.SIG.symRate_net = SIG.symRate_net;

%% Modulation Parameters
TX.QAM = QAM_config(TX.SIG);

%% PRBS Parameters
TX.BIT.source = 'randi';
TX.BIT.seed = 1;
% TX.BIT.degree = 17;
% TX.BIT.applyBitDelay = true;

%% Pulse Shaping Filter Parameters
TX.PS.type = 'RRC';
TX.PS.rollOff = TX.SIG.rollOff;
% TX.PS.nTaps = 32*TX.SIG.nSpS;

%% Pilot Symbols
TX.PILOTS = PILOTS;

%% LASER Impairments
if isfield(SIG,'laserLW')
    TX.LASER.wavelength_nm = 1550;
    TX.LASER.linewidth = SIG.laserLW;
end

%% DAC Parameters
DAC.RESAMP.sampRate = 2*TX.SIG.symRate;
DAC.nBits = Inf;
TX.DAC = DAC;

%% ADC Parameters
% Resampling:
ADC.RESAMP.sampRate = 2*TX.SIG.symRate;
% Low-Pass Filtering:
% ADC.LPF.type = 'Gaussian';
% ADC.LPF.fc = 20e9;
% ADC.LPF.order = 3;
% Quantization:
ADC.nBits = Inf;
RX.ADC = ADC;

