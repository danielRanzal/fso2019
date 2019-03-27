function [NGMI,GMI,MI] = snr2gmi_PCS(SNR_dB,M,E)
%snr2gmi_PCS     Evaluate theorethical MI, GMI and NGMI
%   This function evaluates the theoretical achievable MI, GMI and NGMI 
%   that corresponds to a query SNR and constellation entropy, considering 
%   an AWGN channel. The conversion of SNR into MI, GMI and NGMI is based 
%   on linear interpolation of pre-calculated (simulated) values stored in 
%   look-up tables for each QAM format and constellation entropy. Currently
%   supported QAM formats are:
%   64QAM
%   256QAM
%
%   INPUTS:
%   SNR_dB  :=  signal-to-noise ratio (dB) [1 x nSNR]
%   M       :=  QAM constellation sizes [1 x 1]
%   E       :=  entropy after constellation shaping [1 x 1]
%
%   OUTPUTS:
%   NGMI    :=  normalized generalized mutual information [1 x 1]
%   GMI     :=  generalized mutual information [1 x 1]
%   MI      :=  mutual information [1 x 1]
%
%
%   Examples:
%       [NGMI,GMI,MI] = snr2gmi_PCS(8,64,4);
%
%
%   Author: Fernando Guiomar
%   Last Update: 21/03/2019
   

%% SNR vs MI Table
fileName = [num2str(M) 'QAM_PCS_snr2gmi'];
SNR_vs_GMI = load(fileName);

E_LUT = SNR_vs_GMI.entropy;
% E_LUT(end+1) = log2(M);
% [~,idx] = unique(E_LUT);
% idx = idx(2:end);
% E_LUT = E_LUT(idx);

[SNR_LUT,E_LUT] = meshgrid(SNR_vs_GMI.SNR_dB,E_LUT);
NGMI_LUT = SNR_vs_GMI.NGMI;
% NGMI_LUT(end+1,:) = snr2gmi(SNR_vs_GMI.SNR_dB,M)/M;
% NGMI_LUT = NGMI_LUT(idx,:);
NGMI_LUT(isnan(NGMI_LUT)) = 1;
NGMI_LUT(isinf(NGMI_LUT)) = 0;

% Linear interpolation to find the best-fit GMI for the query SNR and E:
NGMI = interp2(SNR_LUT,E_LUT,NGMI_LUT,SNR_dB,E,'linear',1);
if nargout > 1
    GMI_LUT = SNR_vs_GMI.GMI;
%     GMI_LUT = GMI_LUT(idx,:);
    GMI_LUT(isnan(GMI_LUT)) = E;
    GMI_LUT(isinf(GMI_LUT)) = 0;
    GMI = interp2(SNR_LUT,E_LUT,GMI_LUT,SNR_dB,E,'linear',E);
end
if nargout > 2
    MI_LUT = SNR_vs_GMI.MI;
%     MI_LUT = MI_LUT(idx,:);
    MI_LUT(isnan(MI_LUT)) = E;
    MI_LUT(isinf(MI_LUT)) = 0;
    MI = interp2(SNR_LUT,E_LUT,MI_LUT,SNR_dB,E,'linear',E);
end
