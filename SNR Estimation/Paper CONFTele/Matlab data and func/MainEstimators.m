%% power analysis CONF Tele

clear all
clc


%% loading Data
% load('D:\Users\Pc\Documents\GitHub\fso2019\SNR Estimation\Paper CONFTele\Matlab data and func\2_hours_meas_10_April.mat')
 %load('3_hours_meas_15_April.mat')
%% Fixed Taps Estimator
nTaps = 40; % imposing number of taps to be higher or lower then optimum
%for nTaps=1:20
power=SNR_dB;

    for idx=1:length(power)
        [estFixedTaps(nTaps,:)] = estimate_meanSNR(power,nTaps);
        
    end
    MSE(nTaps)= mean((estFixedTaps(nTaps,2:end)-power(2:end)).^2);
%end
[value,optTaps]=min(MSE)

% getting the best Number of Taps

%% Real time estimator
[dynamicTaps,tapsD]= realTimeEst(power);
MSE_dynamic=(dynamicTaps(2:end)-power(2:end)).^2;

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
figure(),hold on,subplot(3,1,1),hold on,plot(power),plot(estFixedTaps(optTaps,:))...
,title('Fixed Taps'),subplot(3,1,2),hold on,plot(power),plot(dynamicTaps),title('Dynamic estimator'),subplot(3,1,3),hold on,plot(power),plot(differential(2:end)),title('Differential'),hold off

% error
figure(),hold on,subplot(3,1,1),plot((estFixedTaps(optTaps,:)-power).^2)...
,title('Fixed Taps'),subplot(3,1,2),plot(MSE_dynamic),title('Dynamic estimator'),subplot(3,1,3),plot((differential(3:end-2)-power(3:end)).^2),title('Differential'),hold off


