%% getting data


%
%out : power
%   climReading

[ state, obj ] = powerMeterInit( ~ )

numHour=1;
TempSamp= 300;
samplingTime= 4; % 4 seconds beetween samples
for i=1:900*numHour % 1 HOUR
 tic;   
    
 power(i)= measurePower( obj );
 
 
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

