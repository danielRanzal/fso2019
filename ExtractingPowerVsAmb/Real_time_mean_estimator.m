clear all;
close all;
clc;

load ('2_hours_meas_10_April');
SNR_dB=power;

a=[];
real_time_SNR_dB_est=[];
SNR_margin_dB = 2;
symRate = 32e9;
M_PCS = 64;
nPol = 2;
% hold on;
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
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%  REAL TIME PLOT %%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
     if i>1
%       plot(1:i,SNR_dB(1:i));%,1:i,real_time_SNR_dB_est(1:i))
%       hold on
%       plot(1:i,real_time_SNR_dB_est(1:i),'linewidth',2);
        taps(i)=idx2; %see number of taps varying 
     
     
        SNR_dB_withMargin(i) = real_time_SNR_dB_est(i) - SNR_margin_dB;
% %         for n = 1:numel(SNR_dB_withMargin)
            three_taps_AIR(i)=snr2air_PCS(SNR_est_dB(i),nGMIth,M_PCS);
            real_time_AIR(i) = snr2air_PCS(SNR_dB_withMargin(i),nGMIth,M_PCS); %achievable information rate 
            three_taps_NGMI(i)=snr2gmi_PCS(a(i),M_PCS,three_taps_AIR(i));
            real_time_NGMI(i) = snr2gmi_PCS(a(i),M_PCS,real_time_AIR(i));
%             real_time_bitRate(i) = real_time_AIR(i)* symRate * nPol;
            if real_time_NGMI(i)<nGMIth
                real_time_AIR(i)=0;
            end 
            
            if three_taps_NGMI(i)<nGMIth
                three_taps_AIR(i)=0;
            end
            symRate_net=(M_PCS*5/6*15/16)*1e9;
            real_time_bitRate_net(i)=real_time_AIR(i)*symRate_net*nPol;
            three_taps_bitRate_net(i)=three_taps_AIR(i)*symRate_net*nPol;
%             plot(1:i,real_time_bitRate_net(1:i),1:i,bitRate_net(1:i));%,1:i,real_time_SNR_dB_est(1:i))
%             legend('mio','suo','location','northwest');
%         end
     end 
end

%%% FINAL RESULTS %%%
three_taps_MSE = mean((SNR_est_dB(2:end-1)-(a(2:end)-2)).^2)
real_time_MSE = mean((real_time_SNR_dB_est(2:end)-a(2:end)).^2)

n=1:length(SNR_dB);

%%%%% AIR %%%%%
mean_three_taps_AIR=mean(three_taps_AIR)
mean_real_time_AIR=mean(real_time_AIR)
figure,plot(n,three_taps_AIR,n,real_time_AIR);
title('AIR');
legend('3 taps','Real-time','location','southwest');
grid on

%%%%% NGMI %%%%%
figure,plot(n,three_taps_NGMI,n,real_time_NGMI);
hold on
plot(n,nGMIth*ones(1,length(SNR_dB)),'linewidth',2);
legend('3 taps','Real-time','threshold','location','southwest');
title('NGMI');
grid on;
hold off;

%%%%% NET BIT RATE %%%%%
real_time_bit_rate_gain_net=mean_real_time_AIR*symRate_net*nPol
three_taps_bit_rate_gain_net=mean_three_taps_AIR*symRate_net*nPol
figure,plot(n,three_taps_bitRate_net,n,real_time_bitRate_net);
legend('3 taps','Real-time','location','southwest');
title('Net Bit Rate');
grid on;
 

% hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% accumulated? %%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% bitRate_adapt_three_taps = (three_taps_NGMI>nGMIth).*three_taps_AIR*50*2*1e9;
% bitRate_adapt_fed = (real_time_NGMI>nGMIth).*real_time_AIR*50*2*1e9;
% 
% t=1:458;
% accCapacity_adapt_three_taps = cumsum(bitRate_adapt_three_taps).*mean(diff(t))*1e-12/8;
% accCapacity_adapt_fed = cumsum(bitRate_adapt_fed).*mean(diff(t))*1e-12/8;
% 
% plot(t,accCapacity_adapt_three_taps,t,accCapacity_adapt_fed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%    A POSTERIORI PLOT  %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n=1:length(SNR_dB);
figure,plot(n,SNR_dB,n,real_time_SNR_dB_est,n,SNR_est_dB(1:end-1)+2);
title('three taps vs real time estimator')
xlabel('time');
ylabel('SNR [dB]');
legend('SNR','SNR real time estimation','SNR three taps sestimation','location','southeast');
grid on 