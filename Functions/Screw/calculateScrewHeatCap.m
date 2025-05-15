function c = calculateScrewHeatCap(TPP,T)
%Calculates the specific heat of the screw


    if T > TPP.hastelloyX_c(end,1)
        %use maximum tabulate viscosity and tell user
        c = TPP.hastelloyX_c(end,2);
        fprintf("Temperature %.1f K, is too high, max cp for water used (calculateSlurryHeatCap)",T);
    else
         c = lerp([TPP.hastelloyX_c(:,1),TPP.hastelloyX_c(:,2)],T);
    end


end

