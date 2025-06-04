function c = calculateScrewHeatCap(TPP,T)
%Calculates the specific heat of the screw
         c = lerp([TPP.hastelloyX_c(:,1),TPP.hastelloyX_c(:,2)],T);
end

