function cp_s = calculateSlurryHeatCap(globalInputs)
%Calculates the mass averaged specific heat of the slurry

%inputs: uses the mass ratio, and the cp's of water and aluminum

cp_s = (1 / (1 + globalInputs.slurry.massRatio)) * (globalInputs.slurry.massRatio...
        * globalInputs.aluminum.cp + globalInputs.water.cp);

end