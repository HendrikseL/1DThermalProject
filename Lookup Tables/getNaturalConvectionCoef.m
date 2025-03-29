function h_nat = getNaturalConvectionCoef(TPP, T, globalInputs, direction, position)
%calculates the natural convection coefficient for air. To be used in the
%outer pipe heat transfer
%Inputs:
%T: desired temperature
%element: Will determine the correlation needed and the position of the element.

%calculate prandtl number
Pr = lerp([TPP.air(:,1) TPP.air(:,4)],T);
k_air = lerp([TPP.air(:,1) TPP.air(:,2)],T);

g = 9.81; %gravity
beta = 1/T; %volume expansion for ideal gas
T_inf = globalInputs.temperature.Ta;

nu = lerp([TPP.air(:,1) TPP.air(:,3)],T);

switch direction

    case "outerPipe"

        D = globalInputs.outerPipe.OD;
        %calculate Grashoff number
        Gr = (g*beta*(T-T_inf)*D^3)/(nu^2);

        %calculate rayleigh number
        Ra = Gr*Pr;

        Nu = ( 0.6 + (0.387*Ra^(1/6)) / (1+(0.559/Pr)^(9/16))^(8/27) )^2;
        %getting characteristic length
        l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

        h_nat = (Nu*k_air) / l;

    case "flange"
        D = globalInputs.flange.D;
        %calculate Grashoff number
        Gr = (g*beta*(T-T_inf)*D^3)/(nu^2);

        %calculate rayleigh number
        Ra = Gr*Pr;

        Nu_r = ( 0.6 + (0.387*Ra^(1/6)) / (1+(0.559/Pr)^(9/16))^(8/27) )^2;
        %getting characteristic length
        l = globalInputs.flange.t;

        h_nat = (Nu_r*k_air) / l;

        if position(1) == 1 || position(1) == (4+ globalInputs.program.N*globalInputs.program.M)
            L = D/2 - globalInputs.innerPipe.OD;
            Gr = (g*beta*(T-T_inf)*L^3)/(nu^2);

            %calculate rayleigh number
            Ra = Gr*Pr;

            
            Nu_ax = (0.825 + (0.387*Ra^(1/6)) / (1 + (0.492/(Pr^(9/16)))^(8/27) ) )^2;

            h_nat(2) = (Nu_ax*k_air) / l;
        end

end



end

