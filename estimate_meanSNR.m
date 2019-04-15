function [SNR_est] = estimate_meanSNR(SNR,nTaps)

SNR_est = zeros(size(SNR));
for k = 1:numel(SNR)
    idx = k-nTaps:k-1;
    idx = idx(idx>0);
    SNR_est(k) = mean(SNR(idx));
end

end