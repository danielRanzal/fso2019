clear all
    if ~isempty(instrfind)
     fclose(instrfind);
      delete(instrfind);
    end
  %%  
    out1 = instrfind('Type', 'serial')

    
s2 = serial('COM7','BaudRate',115200,'Terminator','CR')
fopen(s2)

tMeas
tic

i=1;
tMeas(1)=0;
while 1    
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
%fprintf(s2,'%s',':OUTP:MEAS?')

tMeas(i)=toc;
while tMeas(i)-tMeas(i-1)<sampleT 
 tMeas(i)=toc;    
end
outPower(i) = fscanf(s2)
out1 = fscanf(s2)
%fclose(s2);
i=i+1;
end
plot(tMeas)