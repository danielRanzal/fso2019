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
     power_lin=10.^((power).*0.1);
     Snr_lin=10.^((Snr_Monitor).*0.1);
x=1;
load('lut.mat');
for y=0:5:75
    
    mean_power(x)=10*log10(mean(power_lin(1+y:5+y)));
    
    mean_SNR(x)=10*log10(mean(Snr_lin(1+y:5+y)));
    SNR(x)=Lut(-mean_power(x),lut);
    x=x+1;
   
end
lut=[-mean_power;mean_SNR;i]';

%% plot results
figure,plot3(lut(:,1),lut(:,2),lut(:,3));
grid on
xlabel('power[dBm]');
ylabel('SNR');
zlabel('Attenuation[dB]');
%%
figure,hold on,plot(lut(:,1),lut(:,2)),plot(lut(:,1),SNR),hold off

%% building lut
function SNR =Lut(Power,lut)

for reg=1:1:length(lut)
    SNR=0;  % just assuring value is always assigned
    if reg==1 && Power>lut(reg,1)   %extreme casses
        SNR = funct2snr(reg,Power);
    else if reg== length(lut)       %extreme casses
            SNR = funct2snr(reg-1,Power);
        else if Power >= lut(reg+1,1)   % usual expectable case
                
                SNR = funct2snr(reg,Power);
        
                break
                
            end
        end
    end

end

end


function snr = funct2snr(reg,power)
load('lut.mat')
    m = (lut(reg+1,2)-lut(reg,2))/(lut(reg+1,1)-lut(reg,1));% 
    b= lut(reg,2)-m*lut(reg,1);
    
    snr = m*power+b; 
    
end