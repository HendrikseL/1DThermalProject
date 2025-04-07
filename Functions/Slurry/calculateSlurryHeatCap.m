function cp_slurry = calculateSlurryHeatCap(TPP,globalInputs,T)
%Calculates the mass averaged specific heat of the slurry

%inputs: uses the mass ratio, and the cp's of water and aluminum
    if T > TPP.water(end,1)
        %use maximum tabulate viscosity and tell user
        cp_water = TPP.water(end,2);
        fprintf("Temperature %.1f K, is too high, max cp for water used (calculateSlurryHeatCap)",T);
    else
         cp_water = lerp([TPP.water(:,1),TPP.water(:,2)],T);
    end

    if T > TPP.aluminum(end,1)
        cp_aluminum = TPP.aluminum(end,1);
        fprintf("Temperature %.1f K, is too high, max cp for aluminum used (calculateSlurryHeatCap)",T);
    else
        cp_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,2)],T);
    end
    
    cp_slurry = globalInputs.aluminum.w*cp_aluminum + globalInputs.water.w*cp_water; 

end