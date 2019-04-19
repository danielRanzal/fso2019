%% power analysis CONF Tele

clear all
clc


%% loading Data
load('D:\Users\Pc\Documents\GitHub\fso2019\SNR Estimation\Paper CONFTele\Matlab data and func\2_hours_meas_10_April.mat')

%% Fixed Taps Estimator
for nTaps=1:100
    for idx=1:length(power)
        [estFixedTaps(nTaps,:)] = estimate_meanSNR(power,nTaps);
        
    end
    MSE(nTaps)= mean((estFixedTaps(nTaps,2:end)-power(2:end)).^2);
end
[value,optTaps]=min(MSE)

% getting the best Number of Taps

%% Real time estimator
[dynamicTaps]= realTimeEst(power);
MSE_dynamic=mean((dynamicTaps(2:end)-power(2:end)).^2);

%% Differencial estimator

% MSEm=1;
% for optTaps=1:100
% [differential,MSE_diff]=estimatordiff(power,optTaps)
%     if MSE_diff<MSEm
%         MSEm=MSE_diff;
%         tapsG=optTaps
%     end
%     
% end
[differential,MSE_diff]=estimatordiff(power,optTaps)

%% Exposing Results
% 

%% all on same graphs
figure(),hold on,title('Power estimations'), plot(power),plot(estFixedTaps(optTaps,:)),plot(dynamicTaps),plot(differential), ...
legend('Real power','Fixed number of Taps','Dynamic taps','Differential'),hold off

figure(),hold on,title('Squared error of estimators'),plot((estFixedTaps(optTaps,:)-power).^2),plot((dynamicTaps-power).^2),plot((differential(2:end)-power).^2), ...
legend('Fixed number of Taps estimation','Fixed number of Taps','Differential'),hold off

%% subploting
% figure(),hold on,subplot(3,1,1),plot(estFixedTaps(optTaps,:))...
% ,title('Fixed Taps'),subplot(3,1,2),plot(dynamicTaps),title('Dynamic estimator'),subplot(3,1,3),plot(differential(2:end)),title('Differential'),hold off
