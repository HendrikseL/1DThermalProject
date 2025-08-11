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
createThermophysicaProperties
globalParams


%Initialize Temperature matrix 
Tdist = initializeTempDistribution(globalInputs);
%convert all temps to Kelvin
Tdist = Tdist(:,:) + 273.15;

%start output file write
if globalInputs.program.writeOutput
        %convert all temps to Celsius for writing (does NOT overwrite temp matrix)
        Tdist_write = Tdist(:,:) - 273.15;
    
    outputFileWrite(globalInputs,Tdist_write,1,0,globalInputs.program.outFile);


    Pdist = globalInputs.slurry.P *ones(globalInputs.program.N*globalInputs.program.M+4,globalInputs.program.radialNodes+5);
    outputFileWrite(globalInputs,Pdist,1,0,globalInputs.program.pOutFile)
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
    % 
    if t <= 5
        Tdist(6,4) = 110+273.15;
    end

    %updates the coefficients for each node
    [ElDist, combMap] = updateElements(ElDist, globalInputs, Tdist, TPP, combMap);

    [A,Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs);
    Q = constructHeatFlowInput(ElVec,Tdist,globalInputs,positionMap);

    %%Solve Equations
    %Explicitly solve equation M.1 (main resistor matrix)
    %responsible for main temperatures and slurry pressure/momentum
    [T_new, ElVec,slurryPositionMap, slurryP,slurryVel] = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap,TPP);

    %Implicitly solve equation M.2 (flange temperatures 1 and 2)
    T_flange(1:2,1) = A2\b2;

    %Implicitly  solve equations M.3 (flange temperatures 3 and 4)
    T_flange(3:4,1) = A3\b3;

    %combines the temperature outputs from the M1, M2 and M3 into the
    %format of Tdist in the documentation and updates the temperature
    Tdist = reconstructTdist(T_new,T_flange,positionMap,Tdist);
    ElDist = reconstructEldist(ElVec,ElDist,positionMap);

    %debug functions, they can be safely commented out
    Pdist = reconstructPdist(globalInputs,slurryP,slurryPositionMap);
    Vdist = reconstructVdist(globalInputs,slurryVel,slurryPositionMap);


    %write output for timestep
    if globalInputs.program.writeOutput && (mod(t,globalInputs.program.writeInterval) == 0)
        %convert all temps to Celsius for writing (does NOT overwrite temp matrix)
        Tdist_write = Tdist(:,:) - 273.15;

        outputFileWrite(globalInputs,Tdist_write,2,t,globalInputs.program.outFile);

        outputFileWrite(globalInputs,Pdist,2,t,globalInputs.program.pOutFile)
    end


    %iterate timestep
    t = t +1;
end

%clear all unwanted variables (comment to debug)
% clearvars -except globalInputs Tdist TPP ElDist
toc