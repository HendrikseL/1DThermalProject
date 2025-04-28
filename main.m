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

%Initialize Temperature matrix 
Tdist = initializeTempDistribution(globalInputs);
%convert all temps to Kelvin
Tdist = Tdist(:,:) + 273.15;

%Initialize resistor elements
ElDist = initializeElementDistribution(globalInputs, Tdist, TPP);
combMap = zeros(length(ElDist(:,1)),length(ElDist(1,:)));

%%Begin Solution Loop
CONVERGED = 0; %convergence flag
i = 1;
while ~CONVERGED && i < 2%globalInputs.program.maxIterations

    cde = calculateBoundaryEffectiveCd(globalInputs, Tdist, TPP);
    [A2, b2, A3, b3] = constructFlangeMatrices(Tdist,TPP,globalInputs,cde);

    [ElDist, combMap] = updateElements(ElDist, globalInputs, Tdist, TPP, combMap);

    %construct coefficient matrix theta
    % [theta_debug, Tvec_debug, b_debug] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs);
    [theta, Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);

    Q = constructHeatFlowInput(ElVec,Tdist,globalInputs);

    %%Solve Equations
    %solve equation M.1 (main resistor matrix)
    T_new =  (theta)\(Q-b)';

    %solve equation M.2 (flange temperatures 1 and 2)
    T_flange(1:2,1) = A2\b2;

    %solve equations M.3 (flange temperatures 3 and 4)
    T_flange(3:4,1) = A3\b3;

    %combines the temperature outputs from the M1, M2 and M3 into the
    %format of Tdist in the documentation
    Tdist_new = reconstructTdist(T_new,T_flange,positionMap,Tdist);

    %%Check Solution Convergance
    Qnet = calculateNetHeatFlow(ElDist,Tdist_new,globalInputs);
    Tc_out = calculateCoolantOutletTemperature(TPP,Tdist_new,globalInputs,Qnet);

    %k counts absolute column position
    k = 2; %offset k, accounts the two columns of inlet temps
    error = zeros(1,globalInputs.program.M);
    converged_array = zeros(1,globalInputs.program.M);
    %count through heat exchangers (M) and sample the Tc,out of each (Tdist at
    %position N)
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

%convert all temps back to Celsius
Tdist = Tdist(:,:) - 273.15;

%clear all unwanted variables (comment to debug)
% clearvars -except globalInputs Tdist TPP ElDist
toc