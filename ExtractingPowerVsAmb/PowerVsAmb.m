%% getting data


%
%out : power
%   climReading

clear all
%     if ~isempty(instrfind)
%      fclose(instrfind);
%       delete(instrfind);
%     end
%   %%  
% out1 = instrfind('Type', 'serial')
% s2 = serial('COM7','BaudRate',115200,'Terminator','CR')
% fopen(s2)

[ state, obj ] = powerMeterInit( ~ )

i=1;
numHour=1;
TempSamp= 300;
samplingTime= 4; % 4 seconds beetween samples

for i=1:900*numHour % 1 HOUR
 tic;   
% %     tic
% 
% % i=1;
% % tMeas(1)=0;
% % while 1    
% fwrite(s2,':')
% fwrite(s2,'O')
% fwrite(s2,'U')
% fwrite(s2,'T')
% fwrite(s2,'P')
% fwrite(s2,':')
% fwrite(s2,'M')
% fwrite(s2,'E')
% fwrite(s2,'A')
% fwrite(s2,'S')
% fprintf(s2,'?') % this one with terminator
% %fprintf(s2,'%s',':OUTP:MEAS?')
% 
% % tMeas(i)=toc;
% % while tMeas(i)-tMeas(i-1)<sampleT 
% %  tMeas(i)=toc;    
% % end
% outPower(i) = fscanf(s2)
% % out1 = fscanf(s2)
% %fclose(s2);
% % i=i+1;
% % end
power(i)= measurePower( obj );
 
 
 if toc >TempSamp    % sampling getAmb each 5 min (refresh on website at least 10 min
 clim(i)=getAmb(); 
 end
    
    while toc< samplingTime     
    end
    
end
% fclose(s2);

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

