function [Tdist] = initializeTempDistribution(globalInputs)
%Initialized the global temperature distribution
%currently lacking input and output conditions

%intialize temperature matrix for speed
Tdist = zeros(5 + globalInputs.program.radialNodes, globalInputs.program.inputPadding...
    + globalInputs.program.N * globalInputs.program.M + globalInputs.program.outputPadding);

offset = globalInputs.program.offset;

%%Initial boundary temps

%input temps and flanges
for j = 1+offset:1:globalInputs.program.radialNodes+offset
    Tdist(j,[1:2]) = globalInputs.temperature.in.Ts;
    Tdist(j,[end-1:end]) = globalInputs.temperature.out.Ts;
end

%screw
Tdist(j+1,[1:2]) = globalInputs.temperature.in.Tsc;
Tdist(j+1,[end-1:end]) = globalInputs.temperature.out.Tsc;

%flange temps
Tdist([1:3],[1:2]) = globalInputs.temperature.in.flange;
Tdist([1:3],[end-1:end]) = globalInputs.temperature.out.flange;

%inner pipe temps
Tdist(4,[1:2]) = globalInputs.temperature.in.Tip;
Tdist(4,[end-1:end]) = globalInputs.temperature.out.Tip;


  
%%Initial Nodal Temps

%Heat exchanger loop (outermost structure)
for k = 1:globalInputs.program.N:globalInputs.program.M*globalInputs.program.N

    %Micro heat exchanger (inner structure)
    for i = globalInputs.program.inputPadding+k:1:globalInputs.program.N+globalInputs.program.inputPadding+k-1

        %create HXer temperatures
        if mod(i-globalInputs.program.inputPadding,globalInputs.program.N) == 1
            %create Tc,out
            Tdist(1,i) = globalInputs.temperature.out.Tc;
        elseif mod(i-globalInputs.program.inputPadding,globalInputs.program.N) == 0
            %create Tc,in
            Tdist(1,i) = globalInputs.temperature.in.Tc;
        else
            %create Ta
            Tdist(1,i) = globalInputs.temperature.Ta;
        end

        %create Top - equal to flange intially
        Tdist(2,i) = globalInputs.temperature.in.flange;

        %create Tc
        Tdist(3,i) = globalInputs.temperature.in.Tc;

        %create Tip
        Tdist(4,i) = globalInputs.temperature.in.Tip;

        %create slurry node, equal to radial position
        for j = 1+offset:1:globalInputs.program.radialNodes+offset
            Tdist(j,i) = globalInputs.temperature.in.Ts;
        end

        %create Tsc screw node - assign position data
        Tdist(j+1,i) = globalInputs.temperature.in.Tsc;

    end

end


%output temps and flanges


end

