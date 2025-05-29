function cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T,alpha)
%Calculates the mass averaged specific heat of the slurry

%inputs: uses the mass ratio, and the cp's of water and aluminum
%reactants
cp_water = lerp([TPP.water(:,1),TPP.water(:,2)],T);
cp_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,3)],T);
    
cp_slurry_reactants = globalInputs.aluminum.w*cp_aluminum + globalInputs.water.w*cp_water;

%products
cp_gas = calculateGasHeatCap(TPP, globalInputs, T);
cp_al2o3 = lerp([TPP.Al2O3.heatCap(:,1), TPP.Al2O3.heatCap(:,2)],T);

phi = calculateProductVolumeRatio(TPP, globalInputs, T);
cp_slurry_products = phi*cp_al2o3 + (1-phi)*cp_gas;


cp_slurry = alpha*cp_slurry_products + (1-alpha)*cp_slurry_reactants;

end