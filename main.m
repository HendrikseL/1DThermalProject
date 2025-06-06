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

%start output file write
if globalInputs.program.writeOutput
        %convert all temps to Celsius for writing (does NOT overwrite temp matrix)
        Tdist_write = Tdist(:,:) - 273.15;

    outputFileWrite(globalInputs,Tdist_write,1,0);
end

%Initialize resistor elements
ElDist = initializeElementDistribution(globalInputs, Tdist, TPP);
combMap = zeros(length(ElDist(:,1)),length(ElDist(1,:)));

%%Begin Solution Loop

%time step counter
t = 1;
while t < globalInputs.program.maxIterations

    cde = calculateFlangeEffectiveCd(globalInputs, Tdist, TPP);
    [A2, b2, A3, b3] = constructFlangeMatrices(Tdist,TPP,globalInputs,cde);
    
    % if t <= 2
    %     Tdist(6,4) = 110+273.15;
    % end

    [ElDist, combMap] = updateElements(ElDist, globalInputs, Tdist, TPP, combMap);

    %construct coefficient matrix theta
    % [A,Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);
    [A,Tvec,b,ElVec,positionMap] = constructCoefMatrix_transient(ElDist,Tdist,globalInputs);

    Q = constructHeatFlowInput(ElVec,Tdist,globalInputs,positionMap);

    %%Solve Equations
    %solve equation M.1 (main resistor matrix)

    T_new =  (A)\(Q-b)';
    % T_new = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,Tdist);

    %solve equation M.2 (flange temperatures 1 and 2)
    T_flange(1:2,1) = A2\b2;

    %solve equations M.3 (flange temperatures 3 and 4)
    T_flange(3:4,1) = A3\b3;

    %combines the temperature outputs from the M1, M2 and M3 into the
    %format of Tdist in the documentation
    Tdist_new = reconstructTdist(T_new,T_flange,positionMap,Tdist);


    %update Tdist
    % Tdist = Tdist + Tdist_new*globalInputs.program.timeStep;
    Tdist = Tdist_new;


    %write output for timestep
    if globalInputs.program.writeOutput && (mod(t,globalInputs.program.writeInterval) == 0)
        %convert all temps to Celsius for writing (does NOT overwrite temp matrix)
        Tdist_write = Tdist(:,:) - 273.15;

        outputFileWrite(globalInputs,Tdist_write,2,t);
    end


    %iterate timestep
    t = t +1;
end

%clear all unwanted variables (comment to debug)
% clearvars -except globalInputs Tdist TPP ElDist
toc