function [cd_screw] = calculateScrewConductionResistance(TPP,globalInputs,T,direction,position)
%Calculate the thermal conduction resistance of the screw

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_hast =getConductionCoef(TPP,T,"hasteloyX");


switch direction

    case "axial"
        A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
        
        cd_screw = (x) /(k_hast *A);

    case "radial"
        %find distance from wall
        dist = (globalInputs.program.radialNodes +5) - position(1);
        D1 = dist*globalInputs.screw.deltaR;

        cd_screw = (log((D1+globalInputs.screw.deltaR)/D1)) / (2*pi*globalInputs.screw.l*k_hast);
    end
end

