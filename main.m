%***********************************************
%
%           Aluminum + Water Reactor
%          Thermal Resistance Network
%
%Author: Luke Hendrikse
%***********************************************
clear
clc

%initialize global parameters (creates struct globalInputs)
globalParams

%%Initialize Temperature matrix and resistor elements
Tdist = initializeTempDistribution(globalInputs);






