% author federico rocco
function [real_time_SNR_dB_est]= realTimeEst(SNR_dB)
for i=1:length(SNR_dB)
%     pause(0.0005); %simulating acquisition
    a(i)=SNR_dB(i);
    % fprintf('%d',a(i));
    if i<100 && i>=2%first samples 
        for n = 1:i %try number of taps (past values) until you have some
            for k = 1:numel(a)
                idx = k-n:k-1;
                idx = idx(idx>0);
                real_time_SNR_dB_est(k) = mean(a(idx));
            end 
        idx2 = ~isnan(real_time_SNR_dB_est);
        MSE(n) = mean((real_time_SNR_dB_est(idx2)-a(idx2)).^2);
        end
        [~,idx2] = min(MSE);
        for k = 1:numel(a)
                idx = k-idx2:k-1;
                idx = idx(idx>0);
                real_time_SNR_dB_est(k) = mean(a(idx));
        end
    end
    if i>=100%remaining samples 
        for n = 1:100 %try up to 100 taps
            for k = (i-100+1):numel(a)
                idx = k-n:k-1;
                idx = idx(idx>0);
                real_time_SNR_dB_est(k) = mean(a(idx));
            end
        idx2 = ~isnan(real_time_SNR_dB_est);
        MSE(n) = mean((real_time_SNR_dB_est(idx2)-a(idx2)).^2);
        end
        [~,idx2] = min(MSE);
        for k = (i-100+1):numel(a)
                idx = k-idx2:k-1;
                idx = idx(idx>0);
                real_time_SNR_dB_est(k) = mean(a(idx));
        end       
    end 
end

end
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%  REAL TIME PLOT %%%%%%%%%%%% 
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%      if i>1
% %       plot(1:i,SNR_dB(1:i));%,1:i,real_time_SNR_dB_est(1:i))
% %       hold on
% %       plot(1:i,real_time_SNR_dB_est(1:i),'linewidth',2);
%         taps(i)=idx2; %see number of taps varying 
%      
%      
%         SNR_dB_withMargin(i) = real_time_SNR_dB_est(i) - SNR_margin_dB;
% % %         for n = 1:numel(SNR_dB_withMargin)
%             three_taps_AIR(i)=snr2air_PCS(SNR_est_dB(i),nGMIth,M_PCS);
%             real_time_AIR(i) = snr2air_PCS(SNR_dB_withMargin(i),nGMIth,M_PCS); %achievable information rate 
%             three_taps_NGMI(i)=snr2gmi_PCS(a(i),M_PCS,three_taps_AIR(i));
%             real_time_NGMI(i) = snr2gmi_PCS(a(i),M_PCS,real_time_AIR(i));
% %             real_time_bitRate(i) = real_time_AIR(i)* symRate * nPol;
%             if real_time_NGMI(i)<nGMIth
%                 real_time_AIR(i)=0;
%             end 
%             
%             if three_taps_NGMI(i)<nGMIth
%                 three_taps_AIR(i)=0;
%             end
%             symRate_net=(M_PCS*5/6*15/16)*1e9;
%             real_time_bitRate_net(i)=real_time_AIR(i)*symRate_net*nPol;
%             three_taps_bitRate_net(i)=three_taps_AIR(i)*symRate_net*nPol;
% %             plot(1:i,real_time_bitRate_net(1:i),1:i,bitRate_net(1:i));%,1:i,real_time_SNR_dB_est(1:i))
% %             legend('mio','suo','location','northwest');
% %         end
%      end 
% end
% end