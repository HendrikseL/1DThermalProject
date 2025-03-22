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
createThermophysicaProperties

%%Initialize Temperature matrix and resistor elements
Tdist = initializeTempDistribution(globalInputs);

%create elements 
ElDist = initializeElementDistribution(globalInputs, Tdist, TPP);
%initial update of elements. creates the coefficient matrix
ElDist = updateElements(ElDist, globalInputs, Tdist, TPP);

%construct coefficient matrix theta
[theta_debug, Tvec_debug] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs);
[theta, Tvec] = constructCoefMatrix(ElDist,Tdist,globalInputs);


