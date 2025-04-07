function [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,direction,position)
%Calculate the thermal conduction resistance of the slurry

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_aluminum=getConductionCoef(TPP,T,"aluminum");

%uses condutction values for water at 1atm. This needs to be updated with a
%new data set.
k_water =getConductionCoef(TPP,T,"water");

k_slurry = globalInputs.slurry.volumeFraction*k_aluminum + (1-globalInputs.slurry.volumeFraction)*k_water;

switch direction

    case "axial"
        % A = globalInputs.screw.p*cosd(45)*globalInputs.screw.deltaR;
        dist = (globalInputs.program.radialNodes +5) - position(1);
        R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;

        A = pi * ((R1+globalInputs.screw.deltaR)^2 - R1^2);
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
        
        cds = (x) /(k_slurry *A);

    case "radial"
        %find distance from wall
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
        dist = (globalInputs.program.radialNodes +5) - position(1);
        D1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;

        cds = (log((D1+globalInputs.screw.deltaR)/D1)) / (2*pi*x*k_slurry);
    case "boundary"
        D2 = globalInputs.screw.bladeD;
        D1 = globalInputs.screw.d;

        A = pi/4 * (D2^2 - D1^2);
        x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
        
        %axial for entire boundary
        cds(1) = (x) /(k_slurry *A);

       %radial of entire boundary
        cds(2) = (log(D2/D1)) / (2*pi*x*k_slurry); 
    end
end