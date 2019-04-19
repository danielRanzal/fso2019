% author Daniel Ranzal

function [Estimative,MSE]=estimatordiff(SNR_dB,taps)

PrevError=0;
count=1;
StepSize=1;
offset=1;
factor=0.006;
factor1=0.02;

Estimative(1:4)=SNR_dB(1:4);
for sample=4:length(SNR_dB)
    PrevError=factor1*(Estimative(sample)-SNR_dB(sample));
    StepSize=factor*(SNR_dB(sample)-SNR_dB(sample-1)); 
    if taps>= sample
        temp=taps;
        taps=sample-1;
        monitorTaps(sample)=taps;
    
        if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1*(1+StepSize+PrevError))*(sum(SNR_dB(sample-taps+1:sample))/(taps)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps+1:sample))/((taps))*(1+StepSize+PrevError)); 
        end
        taps=temp;
    else
        
         if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize+PrevError))*(sum(SNR_dB(sample-taps+1:sample))/(taps)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps+1:sample))/((taps))*1/(1+StepSize+PrevError)); 
         end     
        monitorTaps(sample)=taps;

    end
end
% a(count,:)=[factor,factor1];
    MSE=mean((Estimative(4:end-1)-SNR_dB(4:end)).^2);
 
    
end
