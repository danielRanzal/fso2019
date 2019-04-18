% clear all;
% close all;
% clc;
% load('D:\Onedrive\OneDrive - Universidade de Aveiro\Last year\Tese\SNR estimation\NGMI_vs_time_adaptive\NGMI_vs_time_adaptive.mat')
%load('600_values_meas_09_April.mat')

function [Estimative]=estimatorGrad(SNR_dB)
PrevError=1;
count=1;
% factor=0.01; % optimum val
% factor1=0.17;   %optimum val
StepSize=1;
% factor1=0.7800; % promotes best result 0.1693
% factor1=0.02;   % best for subtraction
offset=1;
taps=3;
%% best 0.166
factor=0.006;
factor1=0.02;
%%
% for factor=0:0.001:0.02
% for factor1=0:0.01:0.2
% for taps=1:100

Estimative(1:4)=SNR_dB(1:4);
for sample=4:length(SNR_dB)
    PrevError=factor1*(Estimative(sample)-SNR_dB(sample-1));
    StepSize=factor*(SNR_dB(sample)-SNR_dB(sample-1)); 
    if taps>= sample
        temp=taps;
        taps=sample-1;
        monitorTaps(sample)=taps;
    
        if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize-PrevError))*(sum(SNR_dB(sample-taps:sample))/(taps+1)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps:sample))/((taps+1))*(1+StepSize-PrevError)); 
        end
        taps=temp;
    else
        
         if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize-PrevError))*(sum(SNR_dB(sample-taps:sample))/(taps+1)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps:sample))/((taps+1))*(1+StepSize-PrevError)); 
        end
        
        
        monitorTaps(sample)=taps;
        
        
    end
end
% a(count,:)=[factor,factor1];
    MSE(count)=mean((Estimative(4:end-1)-SNR_dB(4:end)).^2);

    count=count+1;
    
% end

% 
% figure()
% hold on
% subplot(2,1,1)
% plot(monitorTaps(4:100))
% xlabel('Iteration');
% ylabel('Taps');
% subplot(2,1,2)
% plot(MSE(4:end))
% xlabel('Iteration');
% ylabel('MSE');
% hold off
% 
% [a b]=min(MSE);
% disp(a )
% disp(b)
% figure(),hold on, plot(Estimative(4:end-1)),plot(SNR_dB(4:end)),hold off
% end
% end
% figure(),plot(MSE)
% [value index]=min(MSE)
% MSE(count)=mean((SNR_est_dB(2:end-1)-SNR_dB(2:end)).^2);



%% getting estimation from fernando
% nTaps=3;
% SNR_est = zeros(size(SNR_dB));
% for k = 1:numel(SNR_dB)
%     idx = k-nTaps:k-1;
%     idx = idx(idx>0);
%     SNR_est(k) = mean(SNR_dB(idx));
% end
% 
% MSE_F=mean(((SNR_est(2:end-1)-SNR_dB(3:end)).^2))

% %%
% figure(),plot(SNR_dB),plot(SNR_est),plot(Estimative)
% figure(),hold on,plot(SNR_dB-SNR_est),plot(SNR_dB-Estimative(1:end-1)),hold off

end
