% author Daniel Ranzal

function [Estimative,MSE]=estimatorGrad(SNR_dB)
PrevError=1;
count=1;
% factor=0.01; % optimum val
% factor1=0.17;   %optimum val
StepSize=1;
% factor1=0.7800; % promotes best result 0.1693
% factor1=0.02;   % best for subtraction
offset=1;
taps=3;
%% best 0.166
factor=0.006;
factor1=0.02;
%%
% for factor=0:0.001:0.02
% for factor1=0:0.01:0.2
% for taps=1:100

Estimative(1:4)=SNR_dB(1:4);
for sample=4:length(SNR_dB)
    PrevError=factor1*(Estimative(sample)-SNR_dB(sample-1));
    StepSize=factor*(SNR_dB(sample)-SNR_dB(sample-1)); 
    if taps>= sample
        temp=taps;
        taps=sample-1;
        monitorTaps(sample)=taps;
    
        if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize-PrevError))*(sum(SNR_dB(sample-taps:sample))/(taps+1)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps:sample))/((taps+1))*(1+StepSize-PrevError)); 
        end
        taps=temp;
    else
        
         if StepSize>0   % if positive the step results increase
            Estimative(sample+1) = (1/(1+StepSize-PrevError))*(sum(SNR_dB(sample-taps:sample))/(taps+1)); 
        else            % if negative the step increases negatively     %stepsize*PrevError instead of sum
            Estimative(sample+1) =(sum(SNR_dB(sample-taps:sample))/((taps+1))*(1+StepSize-PrevError)); 
         end     
        monitorTaps(sample)=taps;

    end
end
% a(count,:)=[factor,factor1];
    MSE=mean((Estimative(4:end-1)-SNR_dB(4:end)).^2);
 
    
end
