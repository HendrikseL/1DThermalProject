function [h] = getForcedConvectionCoef(TPP, globalInputs, T, k_slurry,material)
%calculates the forced heat transfer coefficient within the slurry
%Inputs:
%   TPP: thermophysical properties
%   globalInputs: input properties of the slurry
%   T: desired operating temperature

switch material

    case "slurry"
        %getting slurry viscosity
        mu_water = lerp([TPP.water(:,1),TPP.water(:,3)],T);
        phi = globalInputs.slurry.volumeFraction;
        
        mu_slurry = mu_water *(1 + 2.5*phi + 10.05*phi^2 + 0.00273*exp(16.6*phi) );
        
        %getting slurry heat capacity
        cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T);
        
        %Reynolds number and Prandtl number
        Pr = (cp_slurry * mu_slurry) / k_slurry;
        
        Red = (2*globalInputs.slurry.ms)/(globalInputs.screw.r*pi*mu_slurry);

    case "waterCoolant"

        if T < 100
            mu_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,3)],T);
            cp_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,2)],T);
            k_water = lerp([TPP.waterCoolantConduction(:,1),TPP.CoolantConduction(:,2)],T);
        else
            mu_water = TPP.waterCoolant(end,3);
            cp_water = TPP.waterCoolant(end,2);
            k_water = TPP.waterCoolantConduction(end,2);
        end

        
        %Reynolds number and Prandtl number
        Pr = (cp_water * mu_water) / k_water;
        
        Red = (2*globalInputs.slurry.m)/(globalInputs.screw.r*pi*mu_water);
        
end


%moody friction factor (8.21) incopera et al.
f = (0.790*log(Red) - 1.64)^-2;

%Gnielski Correlation (8.63) incopera et al.
Nu = ( (f/8)*(Red - 1000) * Pr) / (1+ 12.7*(f/8)^(1/2)*(Pr^(2/3)-1));

%getting characteristic length
l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

h = (Nu*k_slurry) / l;


end

