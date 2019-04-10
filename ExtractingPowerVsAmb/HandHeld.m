%% getting data


%
%out : power
%   climReading

% [ state, obj ] = powerMeterInit()

%% in case of being the handheld power meter use this 
close all;
clear all;
clc;
    if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
    end
  
    out1 = instrfind('Type', 'serial')
s2 = serial('COM3','BaudRate',115200,'Terminator','CR')
fopen(s2)

%%

numHour=2;
TempSamp= 300;
samplingTime= 4; % 4 seconds beetween samples
a=tic;
for i=1:900*numHour % 1 HOUR
b=tic;   
    
%  power(i)= measurePower( obj );




%% handheal Power meter  
fwrite(s2,':')
fwrite(s2,'O')
fwrite(s2,'U')
fwrite(s2,'T')
fwrite(s2,'P')
fwrite(s2,':')
fwrite(s2,'M')
fwrite(s2,'E')
fwrite(s2,'A')
fwrite(s2,'S')
fprintf(s2,'?') % this one with terminator
out(i).string = fscanf(s2); % string that contains power measurement
out1(i,:) = fscanf(s2); 


                    % process the string to extract power later, if this gives an error comment
                    % % until end of handheald
                    % NumberB=isstrprop(out(i),'digit'); % boolean vector isNumber
                    % start= find(NumberB==1, 1, 'first');
                    % finish = find(NumberB==1,1,'last');
                    % Power(i)=str2num(out(start:finish));

%% end of handHeald


 if toc(a)>TempSamp    % sampling getAmb each 5 min (refresh on website at least 10 min
    clim(i)=getAmb(); 
    a=tic;
 end
    
    while toc(b)< samplingTime     
    end
    
end

%% read power from string 
numSamples=900*numHour;

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


%% interpolating data from amb
% numHour=1;
% time=0:4:(900*numHour);
% clim=(round(rand(1,12)))*10;
% Data(1)=clim(1);    % initialize data
% for idx=2:(12)*numHour   % fill all data positions
% % each time idx value changes 75 samples are collected
% 
%     %for pos=1:75
%     b = clim(idx-1);% is the data inserted
%     m = (clim(idx)-clim(idx-1))/75;    % 
%    % Data((idx-2)*75+1:(idx-2)*75+75)=m*(1:75)+b;
%     Data((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
%     %end
% 
% end
% plot(Data)
% 
