%***********************************************
%
%           Aluminum + Water Reactor
%          Thermal Resistance Network
%
%Author: Luke Hendrikse
%***********************************************
clear
clc
tic

%initialize global parameters (creates struct globalInputs)
globalParams
createThermophysicaProperties

%%Initialize Temperature matrix and resistor elements
Tdist = initializeTempDistribution(globalInputs);
%convert all temps to Kelvin
Tdist = Tdist(:,:) + 273;

ElDist = initializeElementDistribution(globalInputs, Tdist, TPP);


CONVERGED = 0; %convergence flag
%%Begin Solution Loop
i = 1;
while ~CONVERGED && i < globalInputs.program.maxIterations

cde = calculateBoundaryEffectiveCd(globalInputs, Tdist, TPP);
% Tdist = updateBoundaryTemperatures(Tdist,ElDist,TPP,globalInputs,cde);
[A2, b2, A3, b3] = constructFlangeMatrices(Tdist,TPP,globalInputs,cde);

ElDist = updateElements(ElDist, globalInputs, Tdist, TPP);

%construct coefficient matrix theta
[theta_debug, Tvec_debug, b_debug] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs);
[theta, Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);

Q = constructHeatFlowInput(ElVec,Tdist,globalInputs);

%solve equation M.1 (main resistor matrix)
T_new =  (theta)\(Q-b)';

%solve equation M.2 (flange temperatures 1 and 2)
T_flange(1:2,1) = A2\b2;

%solve equations M.3 (flange temperatures 3 and 4)
T_flange(3:4,1) = A3\b3;

Tdist_new = reconstructTdist(T_new,T_flange,positionMap,Tdist);

%check solution convergance
Qnet = calculateNetHeatFlow(ElDist,Tdist_new,globalInputs); 
Tc_out = calculateCoolantOutletTemperature(TPP,Tdist_new,globalInputs,Qnet); 

k = 2;
error = zeros(1,globalInputs.program.M);
converged_array = zeros(1,globalInputs.program.M);
for j = 1:1:globalInputs.program.M
    k = k + globalInputs.program.N;
    error(j) = abs(Tdist(1,k)-Tc_out(j));

    %update Tdist with new Tc_out
    Tdist_new(1,k) = Tc_out(j);

    %if under error threshold, declare this HX converged
    if error(j) < 0.1
        converged_array(j) = 1;
    end
end

%if all HX's are converged set flag to true
if sum(converged_array)/length(converged_array) == 1
    CONVERGED = 1;
end

%update Tdist
Tdist = Tdist_new;
%iterate counter
i = i +1;
end


%clear all unwanted variables (comment to debug)
% clearvars -except globalInputs Tdist TPP ElDist 
toc