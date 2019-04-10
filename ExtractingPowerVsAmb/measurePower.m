function [ outPower ] = measurePower( obj )
%MEASUREPOWER measures the power 
%   outPower = measurePower(obj) measures the power "outPower" 
% that is estimated by the instrument HP 81531A (Lightwave Multimeter - "obj"). 

% Authors: Carlos Ferreira Ribeiro (IT, Aveiro)
% October, 2016

	outPower = str2double(query(obj, 'READ:POW?'));
    %outPower = query(obj, 'READ:POW?', '%s', '%g');

end
