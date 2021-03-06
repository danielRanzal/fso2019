%% getting data


%
%out : power
%   climReading

[ state, obj ] = powerMeterInit()

%% in case of being the handheld power meter use this 
clear all
    if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
    end
  
    out1 = instrfind('Type', 'serial')
s2 = serial('COM7','BaudRate',115200,'Terminator','CR')
fopen(s2)

%%

numHour=1;
TempSamp= 300;
samplingTime= 4; % 4 seconds beetween samples
for i=1:900*numHour % 1 HOUR
 tic;   
    
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
out(1) = fscanf(s2); % string that contains power measurement
out1 = fscanf(s2); 
% process the string to extract power later, if this gives an error comment
% until end of handheald
NumberB=isstrprop(out(i),'digit'); % boolean vector isNumber
start= find(NumberB==1, 1, 'first');
finish = find(NumberB==1,1,'last');
Power(i)=str2num
%% end of handHeald


 if toc >TempSamp    % sampling getAmb each 5 min (refresh on website at least 10 min
 clim(i)=getAmb(); 
 end
    
    while toc< samplingTime     
    end
    
end

%% interpolating data from amb
time=0:4:(900*numHour);
clim=(round(rand(1,12)))*10;
Data(1)=clim(1);    % initialize data
for idx=2:(12)*numHour   % fill all data positions
% each time idx value changes 75 samples are collected

    %for pos=1:75
    b = clim(idx-1);% is the data inserted
    m = (clim(idx)-clim(idx-1))/75;    % 
   % Data((idx-2)*75+1:(idx-2)*75+75)=m*(1:75)+b;
    Data((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    %end

end
plot(Data)

