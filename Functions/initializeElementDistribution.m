function [ElDist] = initializeElementDistribution(globalInputs, Tdist, TPP)
%Initialized the global Element distribution
%currently lacking input and output conditions

%intialize temperature matrix for speed
ElDist = cell(5 + globalInputs.program.radialNodes, globalInputs.program.inputPadding...
    + globalInputs.program.N * globalInputs.program.M + globalInputs.program.outputPadding);

offset = globalInputs.program.offset;

%input temps and flanges


%Heat exchanger loop (outermost structure)
for k = 1:globalInputs.program.N:globalInputs.program.M*globalInputs.program.N

    %Micro heat exchanger (inner structure)
    for i = globalInputs.program.inputPadding+k:1:globalInputs.program.N+globalInputs.program.inputPadding+k-1

        %create Top
        ElDist(2,i) = {outerPipeElement(2,i,globalInputs,TPP, Tdist)};

        %create Tc
        ElDist(3,i) = {coolantElement(3,i,globalInputs,TPP, Tdist)};

        %create Tip
        ElDist(4,i) = {innerPipeElement(4,i,globalInputs,TPP, Tdist)};

        %create slurry node, equal to radial position
        for j = 1+offset:1:globalInputs.program.radialNodes+offset
            ElDist(j,i) = {slurryElement(j,i,globalInputs,TPP, Tdist)};
        end

        %create Tsc screw node - assign position data
        ElDist(j+1,i) = {screwElement(j+1,i,globalInputs,TPP, Tdist)};

    end

end


%output temps and flanges


end


