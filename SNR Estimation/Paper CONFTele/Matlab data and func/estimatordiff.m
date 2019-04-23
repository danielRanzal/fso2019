% author Daniel Ranzal

function [Estimative,MSE]=estimatordiff(SNR_dB,taps)

PrevError=0;
count=1;
StepSize=0;
offset=1;
factor=0.006;
factor1=0.02;
%optimized for 2 h sun
factor=1.0000e-03;
factor1=0.0077;
%optimized for 3 h rain
% factor=9.999999999999999e-05;
factor=0.0002;
factor=0.0260;
% factor1=0.01;
% %
% for factor1=0:1e-3:1e-1
 for factor=0:1e-6:1e-4

Estimative(1:4)=SNR_dB(1:4);
for sample=4:length(SNR_dB)
    PrevError=factor1*(Estimative(sample)-SNR_dB(sample));
    StepSize=factor*(SNR_dB(sample)-SNR_dB(sample-1)); 
    if taps>= sample
        temp=taps;
        taps=sample-1;
        monitorTaps(sample)=taps;
    
        if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize+PrevError))*(sum(SNR_dB(sample-taps+1:sample))/(taps)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps+1:sample))/((taps))/(1+StepSize+PrevError)); 
        end
        taps=temp;
    else
        
         if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize+PrevError))*(sum(SNR_dB(sample-taps+1:sample))/(taps)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps+1:sample))/((taps))/(1+StepSize+PrevError)); 
         end     
        monitorTaps(sample)=taps;

    end
end
    % a(count,:)=[factor,factor1];
    MSE(count)=mean((Estimative(5:end-2)-SNR_dB(5:end-1)).^2);
    fact(count)=factor;
    fact1(count)=factor1;
    count=count+1;% 

% end 
% end

    plot(MSE)
    [a b]=min(MSE)
end
