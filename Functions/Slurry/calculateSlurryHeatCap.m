function cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T)
%Calculates the mass averaged specific heat of the slurry

%inputs: uses the mass ratio, and the cp's of water and aluminum

    cp_water = lerp([TPP.water(:,1),TPP.water(:,2)],T);
    cp_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,2)],T);
    
    cp_slurry = globalInputs.aluminum.w*cp_aluminum + globalInputs.water.w*cp_water; 

end