function Tip= getInnerPipeBoundary(Tdist,TPP,globalInputs,direction,cde)
%updates the boundary temperatures for the inner pipe boundary nodes

switch direction
    %inlet equation
    case "in"
        T = globalInputs.temperature.in.Tip+273.15;

        %thermal resistances
        cdip = calculatePipeConductionResistance(TPP,globalInputs,T,"axial",[4,1]);

        [~,k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[4,1]);
        cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry);

        %Tdist(1,1) is flange 1 temperature
        Tip = cdip*( (T-Tdist(1,1))/cde(1) + (T-(globalInputs.temperature.in.Ts+273.15))/(cdip + cvs)) + T;

    case"out"
        T = globalInputs.temperature.out.Tip+273.15;

        %thermal resistances
        cdip = calculatePipeConductionResistance(TPP,globalInputs,T,"axial",[4,(2+(globalInputs.program.N*globalInputs.program.M))]);

        [~,k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[4,1]);
        cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry);

        %Tdist(1,end) is flange 1 temperature
        Tip = cdip*( (T-Tdist(1,(4+(globalInputs.program.N*globalInputs.program.M))))/cde(4) + (T-(globalInputs.temperature.out.Ts+273.15))/(cdip + cvs)) + T;

end

end

