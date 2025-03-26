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
%convert all temps to Kelvin
Tdist = Tdist(:,:) + 273;

%create elements 
ElDist = initializeElementDistribution(globalInputs, Tdist, TPP);
%initial update of elements. creates the coefficient matrix
ElDist = updateElements(ElDist, globalInputs, Tdist, TPP);

%%Begin Solution Loop

%construct coefficient matrix theta
[theta_debug, Tvec_debug, b_debug] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs);
[theta, Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);

Q = constructHeatFlowInput(ElVec,Tdist,globalInputs);

lhs = theta*(Tvec)';
T_new =  (theta)\(Q-b)';
