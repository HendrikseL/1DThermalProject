function [Tdist] = initializeTempDistribution(globalInputs)
%Initialized the global temperature distribution
%currently lacking input and output conditions

%intialize temperature matrix for speed
Tdist = zeros(5 + globalInputs.program.radialNodes, globalInputs.program.inputPadding...
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
            Tdist(1,i) = globalInputs.temperature.Tc;
        elseif mod(i-globalInputs.program.inputPadding,globalInputs.program.N) == 0
            %create Tc,in
            Tdist(1,i) = globalInputs.temperature.Tc;
        else
            %create Ta
            Tdist(1,i) = globalInputs.temperature.Ta;
        end

        %create Top
        Tdist(2,i) = globalInputs.temperature.Top;

        %create Tc
        Tdist(3,i) = globalInputs.temperature.Tc;

        %create Tip
        Tdist(4,i) = globalInputs.temperature.Tip;

        %create slurry node, equal to radial position
        for j = 1+offset:1:globalInputs.program.radialNodes+offset
            Tdist(j,i) = globalInputs.temperature.Ts;
        end

        %create Tsc screw node - assign position data
        Tdist(j+1,i) = globalInputs.temperature.Tsc;

    end

end


%output temps and flanges


end

