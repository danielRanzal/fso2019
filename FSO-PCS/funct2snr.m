function snr = funct2snr(reg,power)
load('lut.mat')
    m = (lut(reg+1,2)-lut(reg,2))/(lut(reg+1,1)-lut(reg,1));% 
    b= lut(reg,2)-m*lut(reg,1);
    
%     Data((idx-1)*75+1:(idx-1)*75+75)=m*(1:75)+b;
    snr = m*power+b; 
end