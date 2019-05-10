% Data analysis power SNR lut 
clear all;
close all;
clc;

auto_gain=0; %to analyze data without automatic gain control insert 0
    if auto_gain
        load('power_SNR_LUT_AUTOGAIN');
    else 
        load('power_SNR_LUT_NO_AUTOGAIN');
    end
    
    %% power
    numSamples=length(Power_Monitor)
    out=Power_Monitor;
     for b=1:numSamples
 if 0.5<sum(isstrprop(out(b).string,'digit')) % boolean vector isNumber
     B = regexp(out(b).string,'\d*','Match');
    B= str2double(B)
    wave = B(1);
    power(b) = (B(2)+(1E-2)*B(3));
 else
     power(b)=power(b-1);
 end
     
 %aux = -(B(4)+(1E-2)*B(5));
 end

%% Averaging, and building lut
%      power_lin=10.^((power).*0.1);
%      Snr_lin=10.^((Snr_Monitor).*0.1);
x=1;
for y=0:5:75
    
    mean_power(x)=mean(power(1+y:5+y));
%     mean_power(x)=10*log10(mean(power_lin(1+y:5+y)));
% %     snr(x) = funct(reg,mean_power(x));
%     mean_SNR(x)=10*log10(mean(Snr_lin(1+y:5+y)));
    mean_SNR(x)=mean(Snr_Monitor(1+y:5+y));
    x=x+1;
end
lut=[-mean_power;mean_SNR;i]';
x=1;
for y=0:5:75
    s_nr(x)=L_ut(-mean_power(x),lut)
    if y<75
        x=x+1;
    end 
end
%% plot results
% figure,hold on,plot3(lut(:,1),lut(:,2),lut(:,3)),plot3(lut(:,1),s_nr,lut(:,3)),hold off
% grid on
% xlabel('power[dBm]');
% ylabel('SNR');
% zlabel('Attenuation[dB]');
figure,plot(lut(:,2));
hold on 
plot(s_nr);
hold off;
%% building lut
function SNR =L_ut(Power,lut)

for reg=1:length(lut)-1
    
    if (Power<=lut(reg,1)) && (Power > lut(reg+1,1))
        PowerP=0;
        SNR=lut(reg,2);%PowerP*deltaSnr+lut(reg,2)
%         SNR = funct(reg,Power,lut);
%         break;
        return
    end
    % break
end
disp('Error power not within expected')
SNR=0;
end

% function snr = funct(reg,power,lut)
% 
% % PowerP=(-abs(lut(reg,1))+abs(power))/(abs(lut(reg+1,1))-abs(lut(reg,1)));
%     PowerP=0;
%     if (lut(reg+1,2)-lut(reg,2))>0
%         deltaSnr = -(lut(reg+1,2))+(lut(reg,2));
%     else
%         deltaSnr=(lut(reg+1,2))-(lut(reg,2));
%     end
%     snr=PowerP*deltaSnr+lut(reg,2)
% end



