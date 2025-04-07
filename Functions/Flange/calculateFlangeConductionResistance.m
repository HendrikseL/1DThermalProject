function [cd_f, k_f] = calculateFlangeConductionResistance(TPP,globalInputs,T,direction,position)
%Calculate the thermal conduction resistance of the flange

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_f =getConductionCoef(TPP,T,"ss316");
x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);


switch direction

    case "axial"
        %fix me later
        A = pi/4 * (globalInputs.flange.D);
        cd_f = (x) /(k_f *A);

    case "radial"
        %find distance from wall
        dist = (globalInputs.program.radialNodes +5) - position(1);
        D1 = dist*globalInputs.screw.deltaR;

        cd_f = (log((D1+globalInputs.screw.deltaR)/D1)) / (2*pi*x*k_f);
end
end


