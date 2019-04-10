%   Dissertações de Mestrado Integrado - Universidade de Aveiro
%   Free-Space Optics for Ultra-High-Speed Wireless Communications
%   IT - 2018/2019
%   Daniel Ranzal Albergaria
%
%   Orientador:         Paulo Monteiro
%   Co-orientador:      Fernando Guilmar 
%   Colaboradores:      Abel Lorences-Riesgo
%                       Vera Rodrigues
%                       

%% retreiving information from climetua.fis.ua.pt
% 
% sampling time = 0.303 aprox depends also on internet connection

function [OUT]=getAmb(~)
tic
url ='http://climetua.fis.ua.pt/legacy/main/current_monitor/cesamet.htm';
% read font code
fontC=webread(url);

%% Temperature
temp= 'Temperature';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=209;
idx=idx(6)+offset;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+7),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
temperature=str2num(fontC(idx+start-1:idx+finish-1));

%% Humidity
temp= 'Humidity';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=195;
idx=idx(7)+offset;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
humidity=str2num(fontC(idx+start-1:idx+finish-1));

%% dewpoint
temp= 'Dewpoint';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=195;
idx=idx(6)+offset;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
dewpoint=str2num(fontC(idx+start-1:idx+finish-1));

%% wind
temp= 'Wind';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=196;
idx=idx(11)+offset;   % considering 3 digit margin   
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
 
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
wind=str2num(fontC(idx+start-1:idx+finish-1));

%% barometer
temp= 'Barometer';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=196;
idx=idx(9)+offset;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
barometer=str2num(fontC(idx+start-1:idx+finish-1));

%% todaysRain
temp= 'Rain';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=191;
idx=idx(13)+offset;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
todaysRain=str2num(fontC(idx+start-1:idx+finish-1));

%% rain rate
temp= 'Rain Rate';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=196;
idx=idx(4)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
rainRate=str2num(fontC(idx+start-1:idx+finish-1));

%% Storm Total
temp= 'Storm Total';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=198;
idx=idx+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
 start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
StormTotal=str2num(fontC(idx+start-1:idx+finish-1));

%% monthly rain

temp= 'Monthly Rain';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=199;
idx=idx(2)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber 
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
monthlyRain=str2num(fontC(idx+start-1:idx+finish-1));

%% yearly rain

temp= 'Yearly Rain';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=198;
idx=idx(2)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
yearlyRain=str2num(fontC(idx+start-1:idx+finish-1));

%% windChill

temp= 'Wind Chill';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=197;
idx=idx(4)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
windChill=str2num(fontC(idx+start-1:idx+finish-1));

%% THW Index

temp= 'THW Index';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=196;
idx=idx(2)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
thwIndex=str2num(fontC(idx+start-1:idx+finish-1));

%% heat Index
temp= 'Heat Index';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=197;
idx=idx(4)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
heatIndex=str2num(fontC(idx+start-1:idx+finish-1));

%% UV
temp= 'UV';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=189;
idx=idx(5)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
uv=str2num(fontC(idx+start-1:idx+finish-1));

%% solar Radiation
temp= 'Solar Radiation';    % current temperature at hit number 6
idx = strfind(fontC,temp); % getting temperature estimate position 3882 
offset=202;
idx=idx(2)+offset;
NumberB=isstrprop(fontC(idx:idx+15),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
solarRadiation=str2num(fontC(idx+start-1:idx+finish-1));

sampleTime=toc;
%% passing information to structure

OUT.temperature = temperature;
OUT.humidity = humidity;
OUT.wind = wind;
OUT.barometer = barometer;
OUT.todaysRain = todaysRain;
OUT.rainRate = rainRate;
OUT.stormTotal = StormTotal;
OUT.monthlyRain = monthlyRain;
OUT.yearlyRain = yearlyRain;
OUT.thwIndex = thwIndex;
OUT.heatIndex = heatIndex;
OUT.uv = uv;
OUT.solarRadiation = solarRadiation;
OUT.windChill = windChill;
OUT.sampleTime = sampleTime;

end