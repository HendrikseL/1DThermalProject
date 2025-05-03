function [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,direction,position,alpha)
%Calculate the thermal conduction resistance of the slurry

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature
%       alpha -> combustion flag, 0 = no combustion
if alpha == 0
    k_aluminum=getConductionCoef(TPP,T,"aluminum");
    
    %uses conduction values for water at 1atm. This needs to be updated with a
    %new data set.
    k_water =getConductionCoef(TPP,T,"water");
    
    k_slurry = globalInputs.slurry.volumeFraction*k_aluminum + (1-globalInputs.slurry.volumeFraction)*k_water;

else
%use conduction values for products

end



x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
dist = (globalInputs.program.radialNodes +4) - position(1);
%if distance is -1, coressponding to the screw, dist should be 0
if dist < 0
    dist = 0;
end

R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;

switch direction

    case "axial"
        % A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
        A = pi * ((R1+globalInputs.screw.deltaR)^2 - R1^2);
        cds = (x) /(k_slurry *A);

    case "radial"
        %find distance from wall
        cds = (log((R1+globalInputs.screw.deltaR)/R1)) / (2*pi*x*k_slurry);
    end
end