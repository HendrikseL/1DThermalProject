function Ts = getSlurryBoundary(Tdist,El,TPP,globalInputs,direction)
%GETSLURRYBOUNDARY Summary of this function goes here
%   Detailed explanation goes here
switch direction
    %inlet equation
    case "in"
        %thermal resistances
        T = globalInputs.temperature.in.Ts+273.15; %position of slurry inlet temperature
        [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[]);
        [cds_r, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",El.pos);
        cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry);
        cp = calculateSlurryHeatCap(TPP,globalInputs,T);

        cdip = calculatePipeConductionResistance(TPP,globalInputs,T,"radial",[4,3]);

        %upstream temperature
        Ts_up = globalInputs.temperature.in.Ts_up+273.15; %temporary until Ts_up is defined
        [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,El.radialPosition);

        %equation split into LHS and RHS to make it more easily readable
        rhs = (T-globalInputs.temperature.in.Tip+273.15)/(cdip+cvs) + (T - Ts_up)/cds + (T-globalInputs.temperature.in.Tsc+273.15)/cds_r + ...
                    ms_ax*cp*T + ms_r*cp*(globalInputs.temperature.in.Tip+273.15);

        Ts = cds*(rhs - ms_ax*cp*Ts_up - ms_r*cp*globalInputs.temperature.in.Tsc+273.15) + T;

    case "out"
        %thermal resistances
        T = globalInputs.temperature.out.Ts+273.15; %position of slurry inlet temperature
        [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"axial",[]);
        [cds_r, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",El.pos);
        cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry);
        cp = calculateSlurryHeatCap(TPP,globalInputs,T);

        cdip = calculatePipeConductionResistance(TPP,globalInputs,T,"radial",[4,(2+globalInputs.program.N*globalInputs.program.M)]);

        [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,El.radialPosition);

        %equation split into LHS and RHS to make it more easily readable
        rhs = (T-globalInputs.temperature.out.Tip+273.15)/(cdip+cvs) + (T-globalInputs.temperature.out.Tsc+273.15)/cds_r + ...
                    ms_ax*cp*T + ms_r*cp*(globalInputs.temperature.out.Tip+273.15);

        Ts = cds*(rhs - ms_ax*cp*Tdist(El.pos(1),El.pos(2)) - ms_r*cp*(globalInputs.temperature.out.Tsc+273.15)) + T;
end

end

