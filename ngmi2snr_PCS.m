function [SNR_dB] = ngmi2snr_PCS(NGMI,M,E)
%ngmi2snr_PCS     Evaluate the theoretical SNR that corresponds to given
%                 measured NGMI, constellation template for probabilistic
%                 shaping (M) and signal entropy (E)
%
%   INPUTS:
%   NGMI    :=  normalized generalized mutual information [1 x 1]
%   M       :=  QAM constellation sizes [1 x 1]
%   E       :=  entropy after constellation shaping [1 x 1]
%
%   OUTPUTS:
%   SNR_dB  :=  signal-to-noise ratio (dB) [1 x 1]
%
%
%   Examples:
%       [SNR_dB] = ngmi2snr_PCS(0.9,256,6);
%
%
%   Author: Fernando Guiomar
%   Last Update: 22/03/2019

%% Find Best SNR using fminsearch
options = optimset('MaxFunEvals',1e4,'TolX',1e-1,'TolFun',1e-1,...
    'Display','none','PlotFcns',[]);
[SNR_dB] = fminsearch(@(SNR) snr2gmi_err(SNR,M,E,NGMI),10,options);

end

%% Aux Function
function [err] = snr2gmi_err(SNR_dB,M,E,nGMI_query)
    nGMI = snr2gmi_PCS(SNR_dB,M,E);
    err = abs(nGMI-nGMI_query);
end
