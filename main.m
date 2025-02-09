%***********************************************
%
%           Aluminum + Water Reactor
%          Thermal Resistance Network
%
%
%Author: Luke Hendrikse
%***********************************************
clear
clc

%initialize global parameters
globalParams

%instantiate slurry nodes based on user parameters
slurryNode = cell(globalInputs.program.radialNodes, globalInputs.program.N);
for i = 1:1:globalInputs.program.radialNodes
    for j = 1:1:globalInputs.program.N
        %row 1 is the interface with ip. row radialNodes is interface with
        %sc
        slurryNodes(i,j) = slurryNode;
    end
end
 

%M is a 3D part, it should be outermost loop

T_slurry = constructSlurryTemperatureMatrix(globalInputs,slurryNodes);



