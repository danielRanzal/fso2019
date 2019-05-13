function SNR =Lut(Power,lut)

for reg=1:1:length(lut)
    SNR=0;  % just assuring value is always assigned
    if reg==1 && Power>lut(reg,1)   %extreme casses
        SNR = funct2snr(reg,Power);
    else if reg== length(lut)       %extreme casses
            SNR = funct2snr(reg-1,Power);
        else if Power >= lut(reg+1,1)   % usual expectable case
                
                SNR = funct2snr(reg,Power);
                %      disp(Power)
                % disp(lut(reg,1))
                % pause(1)
                break
                
            end
        end
    end
    %if Power<= lut(reg,1)
    
    % break
end

end