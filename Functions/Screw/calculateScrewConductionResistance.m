function [cd_screw] = calculateScrewConductionResistance(TPP,globalInputs,T,direction,position,type)
%Calculate the thermal conduction resistance of the screw

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_hast =getConductionCoef(TPP,T,"hasteloyX");
x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

switch direction

    case "axial"
        A = pi/4 * (globalInputs.screw.d)^2;

        
        cd_screw = (x) /(k_hast *A);

    case "radial"
        if strcmp(type,"slurry")
            x = globalInputs.screw.lead*x*globalInputs.screw.bladeT;
        end
        %find distance from wall
        dist = (globalInputs.program.radialNodes +5) - position(1);
        D1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;

        cd_screw = (log((D1+globalInputs.screw.deltaR)/D1)) / (2*pi*x*k_hast);
    end
end

