%% FSO PAPERCONFTELE DATA ANALYSIS
clear all;
close all;
clc;

load('taps2H');
load('taps3H');
load('3EstimatorsData_Optimized_3_hours');
power3hours=tapsD;
% power3hours=power;
num3Hour_min=numHour*60; %hours expressed in minutes
maxSamples3=length(power3hours);
n3=0:num3Hour_min/(maxSamples3-1):num3Hour_min; %transform axis in minute timed axis
new_lag3=-(num3Hour_min):num3Hour_min/(maxSamples3-1):(num3Hour_min);
estFixedTaps3=estFixedTaps;

load('3EstimatorsData_Optimized_2_hours'); %do we have a 3 hours? 
power2hours=Taps2H;
% power2hours=power;
num2Hour_min=numHour*60; %hours expressed in minutes
maxSamples2=length(power2hours);
n2=0:num2Hour_min/(maxSamples2-1):num2Hour_min; %transform axis in minute timed axis
new_lag2=-(num2Hour_min):num2Hour_min/(maxSamples2-1):(num2Hour_min)
estFixedTaps2=estFixedTaps;

figure;
subplot(2,1,1)
plot(n2,power2hours);
% axis([0 120 0 3.5]);
grid on;
xticks([20 40 60 80 100 120])
% xlabel('Time (min)','interpreter','Latex');
ylabel('Number of Taps','interpreter','Latex')
title('2 Hours Sunny Data','interpreter','Latex');
set(gca,'fontsize',11);
% set(gcf, 'units', 'centimeters')
% pos=get(gcf, 'position');
% set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
% set(gcf, 'Color', 'None')
% print(gcf,'3Estimations_errors_2_hours_corrected.pdf', '-dpdf', '-r300')
% hold on
% figure,
subplot(2,1,2)
plot(n3,power3hours);
% axis([0 180 0 3.5]);
grid on;
xticks([30 60 90 120 150 180])
xlabel('Time (min)','interpreter','Latex');
ylabel('Number of Taps','interpreter','Latex')
title('3 Hours Rainy Data','interpreter','Latex');
set(gca,'fontsize',11);
set(gcf, 'units', 'centimeters')
pos=get(gcf, 'position');
set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
set(gcf, 'Color', 'None')
% print(gcf,'3Estimations_errors_3_hours_corrected.pdf', '-dpdf', '-r300')
print(gcf,'Number_of_taps_variation_adaptive', '-dpdf', '-r300')
return;

% return;
% AUTOCORRELATION
% figure;
% extrCorr3=power3hours-mean(power3hours);
% [cor3,lags3]=xcorr(extrCorr3);
% normCorr3=abs(cor3)/max(cor3);
% semilogy(new_lag3,normCorr3);
% 
% grid on;
% hold on;
% extrCorr2=power2hours-mean(power2hours);
% [cor2,lags2]=xcorr(extrCorr2);
% normCorr2=abs(cor2)/max(cor2);
% semilogy(new_lag2,normCorr2);
% axis([-40 40 1e-2 1]);
% xlabel('Time (min)','interpreter','Latex');
% legend('Rain','Sun');
% set(gca,'fontsize',12);
% %%%% TO SAVE IN PDF %%%% 
% set(gcf, 'units', 'centimeters')
% pos=get(gcf, 'position');
% set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
% set(gcf, 'Color', 'None')
% print(gcf,'overimposed_autocorrelation_corrected.pdf', '-dpdf', '-r300')
%  return;


% figure;
% box on;
% h1=subplot(3,1,1);
% p1=get(h1,'position');
% plot(n2,power2hours);
% hold on;
% plot(n2,estFixedTaps(optTaps,:),'linewidth',1);
% hold off;
% grid on;
% % axis([0 num3Hour_min 0 4.3]);
% ylabel('Power [dBm]','interpreter','Latex')
% title('MA-fixed','interpreter','Latex');
% set(gca,'fontsize',11);
% 
% h2=subplot(3,1,2);
% p2=get(h2,'position');
% plot(n2,power2hours);
% hold on;
% plot(n2,dynamicTaps,'linewidth',1);
% hold off;
% grid on;
% % axis([0 num3Hour_min 0 4.3]);
% ylabel('Power [dBm]','interpreter','Latex')
% title('MA-adaptive','interpreter','Latex');
% set(gca,'fontsize',11);
% 
% h3=subplot(3,1,3);
% p3=get(h3,'position');
% plot(n2,power2hours);
% hold on;
% plot(n2,differential(1:end-1),'linewidth',1);
% hold off;
% grid on;
% % 
% % axis([0 num3Hour_min 0 4.3]);
% xlabel('Time (min)','interpreter','Latex');
% ylabel('Power [dBm]','interpreter','Latex')
% title('MA-feedback','interpreter','Latex');
% set(gca,'fontsize',11);
% 
% %%%% TO SAVE IN PDF %%%% 
% set(gcf, 'units', 'centimeters')
% pos=get(gcf, 'position');
% set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
% set(gcf, 'Color', 'None')
% print(gcf,'3Estimations_2_hours_corrected.pdf', '-dpdf', '-r300')

figure;
subplot(2,1,1)
plot(n2,(estFixedTaps2(optTaps,:)-power2hours).^2);
axis([0 120 0 3.5]);
grid on;
xticks([20 40 60 80 100 120])
% xlabel('Time (min)','interpreter','Latex');
ylabel('Squared Error','interpreter','Latex')
title('2 Hours Sunny Data','interpreter','Latex');
set(gca,'fontsize',11);
% set(gcf, 'units', 'centimeters')
% pos=get(gcf, 'position');
% set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
% set(gcf, 'Color', 'None')
% print(gcf,'3Estimations_errors_2_hours_corrected.pdf', '-dpdf', '-r300')
% hold on
% figure,
subplot(2,1,2)
plot(n3,(estFixedTaps3(optTaps,:)-power3hours).^2);
axis([0 180 0 3.5]);
grid on;
xticks([30 60 90 120 150 180])
xlabel('Time (min)','interpreter','Latex');
ylabel('Squared Error','interpreter','Latex')
title('3 Hours Rainy Data','interpreter','Latex');
set(gca,'fontsize',11);

% set(gcf, 'units', 'centimeters')
% pos=get(gcf, 'position');
% set(gcf, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)])
% set(gcf, 'Color', 'None')
% print(gcf,'3Estimations_errors_3_hours_corrected.pdf', '-dpdf', '-r300')
% print(gcf,'3Estimations_errors_corrected.pdf', '-dpdf', '-r300')
