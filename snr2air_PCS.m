function [AIR] = snr2air_PCS(SNR_dB,NGMI,M)
%snr2air_PCS    Evaluate the achievable information rate (AIR) that matches
%               the operating SNR, considering a given NGMI threshold and a
%               given M-QAM template for PCS
%
%   INPUTS:
%   SNR_dB  :=  signal-to-noise ratio (dB) [1 x 1]
%   M       :=  QAM constellation sizes [1 x 1]
%   NGMI    :=  normalized generalized mutual information [1 x 1]
%
%   OUTPUTS:
%   AIR     :=  achievable information rate after constellation shaping [1 x 1]
%
%
%   Examples:
%       [AIR] = snr2air_PCS(15,0.9,256);
%
%
%   Author: Fernando Guiomar
%   Last Update: 22/03/2019

%% Find Best SNR using fminsearch
options = optimset('MaxFunEvals',1e4,'TolX',1e-2,'TolFun',1e-2,...
    'Display','none','PlotFcns',[]);
% AIR = fminsearch(@(E) snr2gmi_err(SNR_dB,M,E,NGMI),log2(M)-1,options);
AIR = fminbnd(@(E) snr2gmi_err(SNR_dB,M,E,NGMI),1,log2(M),options);

end

%% Aux Function
function [err] = snr2gmi_err(SNR_dB,M,E,nGMI_query)
    nGMI = snr2gmi_PCS(SNR_dB,M,E);
    err = abs(nGMI-nGMI_query);
end
