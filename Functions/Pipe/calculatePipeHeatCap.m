function c = calculatePipeHeatCap(TPP,T)

    if T > TPP.ss316_c(end,1)
        %use maximum tabulate viscosity and tell user
        c = TPP.ss316_c(end,2);
        fprintf("Temperature %.1f K, is too high, max cp for water used (calculateSlurryHeatCap)",T);
    else
         c = lerp([TPP.ss316_c(:,1),TPP.ss316_c(:,2)],T);
    end
end

