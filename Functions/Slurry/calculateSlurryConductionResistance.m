function [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,direction,position,alpha)
%Calculate the thermal conduction resistance of the slurry

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature
%       alpha -> extent of reaction, 0 = no combustion

%reactants
k_aluminum=getConductionCoef(TPP,T,"aluminum");
k_water =getConductionCoef(TPP,T,"water");

k_slurry_reactants = globalInputs.slurry.volumeFraction*k_aluminum + (1-globalInputs.slurry.volumeFraction)*k_water;


%products
k_steam = getConductionCoef(TPP, T, "steam");
k_h2 = getConductionCoef(TPP, T, "h2");
k_gas = calculateGasConductionCoef(globalInputs,k_steam,k_h2);
k_al2o3 = getConductionCoef(TPP, T, "al2o3");

phi = calculateProductVolumeRatio(TPP, globalInputs, T);
k_slurry_products = phi*k_al2o3 + (1-phi)*k_gas;

%overall slurry (currently only a binary)
k_slurry = alpha*k_slurry_products + (1-alpha)*k_slurry_reactants;


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