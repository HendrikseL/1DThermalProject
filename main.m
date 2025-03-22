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

%convert all temps to Kelvin
% Property tables are in celsius, Tdist must be in celsius for elements to
% update
Tdist = Tdist(:,:) + 273;

%%Begin Solution Loop

%construct coefficient matrix theta
[theta_debug, Tvec_debug, b_debug] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs);
[theta, Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);

Q = constructHeatFlowInput(ElVec,Tdist,globalInputs);

T_new =  inv(theta) * (Q-b)';
