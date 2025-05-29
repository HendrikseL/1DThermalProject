function cp_gas = calculateGasHeatCap(TPP, globalInputs, T)
%calculates the heat capacity of the product gas

cp_steam = lerp([TPP.Steam.heatCap(:,1),TPP.Steam.heatCap(:,2)],T);
cp_h2 = lerp([TPP.H2(:,1), TPP.H2(:,2)],T);

cp_gas = globalInputs.chemistry.X_H2*cp_h2 + globalInputs.chemistry.X_Steam*cp_steam;
end

