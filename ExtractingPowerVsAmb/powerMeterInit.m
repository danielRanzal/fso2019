function [ state, obj ] = powerMeterInit( ~ )
%POWERMETERINIT initializes the power meter
%   [state, obj] = powerMeterInit() connects the computer with the instrument
% HP 81531A (Lightwave Multimeter - "obj"), via GPIB interface. If "state" 
% is 0, the connection with power meter was successful.

% Authors: Carlos Ferreira Ribeiro (IT, Aveiro)
% October, 2016

    % Create the GPIB object if it does not exist
    % otherwise use the object that was found
    global obj
    MaxOutputBufferSize = 2^17;
    obj = instrfind('Type', 'visa-gpib', 'BoardIndex', 0, 'PrimaryAddress', 2, 'Tag', '');
    if isempty(obj)
        obj = visa('agilent', 'GPIB0::2::INSTR');
    else
        fclose(obj);
        obj = obj(1);
    end

    % Connect to instrument object, obj
    fclose(obj);
    obj.OutputBufferSize = MaxOutputBufferSize;    
    try
        fopen(obj);
        
        set(obj, 'Timeout', 10);
        obj.UserData = 'obj';

        power_unit = '+0';                  % Power unit [dBm - '+0' and W - '+1'] 
        wavelength = '+1.54500000E-006';    % Laser wavelength [m]

        % Communicating with instrument object, obj
        name = query(obj, '*IDN?');
        if ~isempty(name)
            disp([name(1:end-1) ' is connected']);

            % Choose power unit
            GPIBSend(obj, ['SENSE:POW:UNIT ' power_unit]);

            % Choose wavelength
            GPIBSend(obj, ['SENSE:POW:WAVE ' wavelength]);

            state = 0;  % Success
        else
            state = 1;  % Failure
            disp('Error in powerMeterInit function! Name is empty');
        end
    catch
        state = 1;  % Failure
        disp('Error in powerMeterInit function!');
    end
        
end

