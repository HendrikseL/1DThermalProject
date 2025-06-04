function c = calculatePipeHeatCap(TPP,T)
         c = lerp([TPP.ss316_c(:,1),TPP.ss316_c(:,2)],T);
end

