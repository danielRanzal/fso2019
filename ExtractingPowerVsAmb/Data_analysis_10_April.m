clear all;
close all;
clc;

%% plot Power_vs_weather

load('2_hours_meas_10_April');
numHour=2;
TempSamp= 300; %seconds between data catch from web
samplingTime= 4; % 4 seconds beetween samples
span=(TempSamp/samplingTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% Extractin data from struct %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:23
        temper(i)=clim(i*(span+1)).temperature;
        humid(i)=clim(i*(span+1)).humidity;
        wi(i)=clim(i*(span+1)).wind;
        barom(i)=clim(i*(span+1)).barometer;
        todRain(i)=clim(i*(span+1)).todaysRain;
        Rainrate(i)=clim(i*(span+1)).rainRate;
        StTotal(i)=clim(i*(span+1)).stormTotal;
        monRain(i)=clim(i*(span+1)).monthlyRain;
        YRain(i)=clim(i*(span+1)).yearlyRain;
        thw(i)=clim(i*(span+1)).thwIndex;
        HIndex(i)=clim(i*(span+1)).heatIndex;
        UV(i)=clim(i*(span+1)).uv;
        solarRad(i)=clim(i*(span+1)).solarRadiation;
        Wchill(i)=clim(i*(span+1)).windChill;
        STime(i)=clim(i*(span+1)).sampleTime;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Interpolating data from amb %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

numHour=2;
time=0:4:(900*numHour);
temp(1:75)=temper(1);    % initialize data
hum(1:75)=humid(1);
win(1:75)=wi(1);
bar(1:75)=barom(1);
today_rain(1:75)=todRain(1);
rain_rate(1:75)=Rainrate(1);
storm_total(1:75)=StTotal(1);
monthly_rain(1:75)=monRain(1);
yearly_rain(1:75)=YRain(1);
thw_index(1:75)=thw(1);
heat_index(1:75)=HIndex(1);
u_v(1:75)=UV(1);
solar_radiation(1:75)=solarRad(1);
wind_chill(1:75)=Wchill(1);
sample_time(1:75)=STime(1);


for idx=2:length(temper)%*numHour   % fill all data positions
% each time idx value changes 75 samples are collected

    %%%%%%%%%%  TEMPERATURE  %%%%%%%%%%
    
    b = temper(idx-1);% is the data inserted
    m = (temper(idx)-temper(idx-1))/75;    % 
    temp((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  HUMIDITY  %%%%%%%%%%
    
    b = humid(idx-1);% is the data inserted
    m = (humid(idx)-humid(idx-1))/75;    % 
    hum((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  WIND  %%%%%%%%%%
    
    b = wi(idx-1);% is the data inserted
    m = (wi(idx)-wi(idx-1))/75;    % 
    win((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  BAROMETER  %%%%%%%%%%
    
    b = barom(idx-1);% is the data inserted
    m = (barom(idx)-barom(idx-1))/75;    % 
    bar((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  TODAY RAIN  %%%%%%%%%%
    
    b = todRain(idx-1);% is the data inserted
    m = (todRain(idx)-todRain(idx-1))/75;    % 
    today_rain((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  RAIN RATE  %%%%%%%%%%
    
    b = Rainrate(idx-1);% is the data inserted
    m = (Rainrate(idx)-Rainrate(idx-1))/75;    % 
    rain_rate((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  STORM TOTAL  %%%%%%%%%%
    
    b = StTotal(idx-1);% is the data inserted
    m = (StTotal(idx)-StTotal(idx-1))/75;    % 
    storm_total((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  MONTHLY RAIN  %%%%%%%%%%
    
    b = monRain(idx-1);% is the data inserted
    m = (monRain(idx)-monRain(idx-1))/75;    % 
    monthly_rain((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  YEARLY RAIN  %%%%%%%%%%
    
    b = YRain(idx-1);% is the data inserted
    m = (YRain(idx)-YRain(idx-1))/75;    % 
    yearly_rain((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  THW INDEX  %%%%%%%%%%
    
    b = thw(idx-1);% is the data inserted
    m = (thw(idx)-thw(idx-1))/75;    % 
    thw_index((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  HEAT INDEX  %%%%%%%%%%
    
    b = HIndex(idx-1);% is the data inserted
    m = (HIndex(idx)-HIndex(idx-1))/75;    % 
    heat_index((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  UV  %%%%%%%%%%
    
    b = UV(idx-1);% is the data inserted
    m = (UV(idx)-UV(idx-1))/75;    % 
    u_v((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  SOLAR RADIATION  %%%%%%%%%%
    
    b = solarRad(idx-1);% is the data inserted
    m = (solarRad(idx)-solarRad(idx-1))/75;    % 
    solar_radiation((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  WIND CHILL  %%%%%%%%%%
    
    b = Wchill(idx-1);% is the data inserted
    m = (Wchill(idx)-Wchill(idx-1))/75;    % 
    wind_chill((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    
    %%%%%%%%%%  SAMPLE TIME  %%%%%%%%%%
    
    b = STime(idx-1);% is the data inserted
    m = (STime(idx)-STime(idx-1))/75;    % 
    sample_time((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%normalizing data%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tempMax=max(temp);
humMax=max(hum);
windMax=max(win);
barometerMax=max(bar);
today_rainMax=max(today_rain);
rain_rateMax=max(rain_rate);
stormMax=max(storm_total);
monthRainMax=max(monthly_rain);
yearRainMax=max(yearly_rain);
thwMax=max(thw_index);
heatMax=max(heat_index);
uvMax=max(u_v);
solarRadiationMax=max(solar_radiation);
windChillMax=max(wind_chill);
sampleTimeMax=max(sample_time);
PowerMax=max(power);

figure()
hold on
plot(temp./tempMax)
plot(hum./humMax)
plot(win./windMax)
plot(bar./barometerMax)
% plot(today_rain./today_rainMax)
% plot(rain_rate./rain_rateMax)
% plot(storm_total./stormMax)
% plot(monthly_rain./monthRainMax)
% plot(yearly_rain./yearRainMax)
% plot(thw_index./thwMax)
% plot(heat_index./heatMax)
% plot(u_v./uvMax)
% plot(solar_radiation./solarRadiationMax)
% plot(wind_chill./windChillMax)
% plot(sample_time./sampleTimeMax)
plot(power./PowerMax)
% plot(SNR_dB_est/max(SNR_dB_est));
title ('2 hours measurements 10 April');
legend('Temp','humidity','wind','pressure','power','location','southwest');
xlabel('4 seconds unit time [s]');
ylabel('Normalized values');
grid on
hold off


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% evaluate effect with mean value %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
