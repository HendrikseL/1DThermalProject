function h_nat = getNaturalConvectionCoef(TPP, T, globalInputs, direction, position)
%calculates the natural convection coefficient for air. To be used in the
%outer pipe heat transfer
%Inputs:
%T: desired temperature
%element: Will determine the correlation needed and the position of the element.

%calculate prandtl number
Pr = lerp([TPP.air(:,1) TPP.air(:,4)],T);
k_air = lerp([TPP.air(:,1) TPP.air(:,2)],T);

switch direction

    case "outerPipe"
        g = 9.81; %gravity
        beta = 1/T; %volume expansion for ideal gas
        T_inf = globalInputs.temperature.Ta;
        D = globalInputs.outerPipe.OD;

        nu = lerp([TPP.air(:,1) TPP.air(:,3)],T);

        %calculate Grashoff number
        Gr = (g*beta*(T-T_inf)*D^3)/(nu^2);

        %calculate rayleigh number
        Ra = Gr*Pr;

        Nu = ( 0.6 + (0.387*Ra^(1/6)) / (1+(0.559/Pr)^(9/16))^(8/27) )^2;
        %getting characteristic length
        l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

        h_nat = (Nu*k_air) / l;

    case "flange"
        %do nothing

end



end

