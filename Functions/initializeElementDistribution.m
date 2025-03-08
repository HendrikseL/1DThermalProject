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

        %create HXer temperatures
        if mod(i-globalInputs.program.inputPadding,globalInputs.program.N) == 1
            %create Tc,out
            ElDist(1,i) = {"Tc,out"};
        elseif mod(i-globalInputs.program.inputPadding,globalInputs.program.N) == 0
            %create Tc,in
            ElDist(1,i) = {"Tc,in"};
        else
            %create Ta
            ElDist(1,i) = {"Tc"};
        end

        %create Top
        ElDist(2,i) = {"Top"};

        %create Tc
        ElDist(3,i) = {"Tc"};

        %create Tip
        ElDist(4,i) = {"Tip"};

        %create slurry node, equal to radial position
        for j = 1+offset:1:globalInputs.program.radialNodes+offset
            ElDist(j,i) = {slurryElement(j,i,globalInputs)};
        end

        %create Tsc screw node - assign position data
        ElDist(j+1,i) = {"Tsc"};

    end

end


%output temps and flanges


end


