function cp_cool = calculateCoolantHeatCap(TPP,globalInputs,T)
%Calculates the mass averaged specific heat of the slurry

%inputs: calculates cp of coolant water. Right now this is assumed to be
%under standard atmosphere, this is subject to change

if T < TPP.waterCoolant(end,1)
    cp_cool = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,2)],T);
else
    cp_cool = TPP.waterCoolant(end,2);
end

end