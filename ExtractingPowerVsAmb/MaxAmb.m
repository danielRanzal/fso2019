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
%% High's and low's
function [OUT] = MaxAmb(~)

url ='http://climetua.fis.ua.pt/legacy/main/current_monitor/cesamet.htm';
% read font code
fontC=webread(url);
 
%% HighTemp
temp= 'High Temperature';    % current temperature at hit number 6
idxName=strfind(fontC,temp); % getting temperature estimate position 3882 
offset=239;
idx=idxName(3)+offset;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
highTemp=str2num(fontC(idx+start-1:idx+finish-1));

% hour of occurence

offsetH= 84;
idx=offsetH+idx;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
HourhighTemp=(fontC(idx+start-1:idx+finish-1));

%% lowTemp

temp= 'Low Temperature';    % current temperature at hit number 6
idxName=strfind(fontC,temp); % getting temperature estimate position 3882 
offset=319;
idx=idxName(3)+offset;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
lowTemp=str2num(fontC(idx+start-1:idx+finish-1));

%hour of occurence
offset=80;
idx=idx+offset;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
HourLowTemp=(fontC(idx+start-1:idx+finish-1));

%% HighHumidity

temp= 'High Humidity';    % current temperature at hit number 6
idxName=strfind(fontC,temp); % getting temperature estimate position 3882 
idxName=idxName(3);
offset=233;
idx=idxName+offset;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
HighHumidity=str2num(fontC(idx+start-1:idx+finish-1));

% hour of occurence
offsetH=80;     % position offset between variable name and value
idx=idx+offsetH;   % considering 3 digit margin  
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
HourHighHumidity=(fontC(idx+start-1:idx+finish-1));

%% LowHumidity
temp= 'Low Humidity';    % current temperature at hit number 6
idxName=strfind(fontC,temp); % getting temperature estimate position 3882 
idxName=idxName(3);
offset=314;     % position offset between variable name and value
idx=idxName+offset;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
LowHumidity=str2num(fontC(idx+start-1:idx+finish-1));

%hour of occurence
offsetH= 79;    % offset between hour and variable result
idx=idx+offsetH;
NumberB=isstrprop(fontC(idx:idx+10),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
HourLowHumidity=(fontC(idx+start-1:idx+finish-1));

%% passing information to structure
OUT.highTemp=highTemp;
OUT.HourhighTemp=HourhighTemp;
OUT.lowTemp=lowTemp;
OUT.HourLowTemp=HourLowTemp;
OUT.HighHumidity=HighHumidity;
OUT.HourHighHumidity=HourHighHumidity;
OUT.LowHumidity=LowHumidity;
OUT.HourLowHumidity=HourLowHumidity;

end