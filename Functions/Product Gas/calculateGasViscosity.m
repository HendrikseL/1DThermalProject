function mu_gas = calculateGasViscosity(TPP, globalInputs, T)
%gets the gas dynamic viscosity

mu_steam = lerp(TPP.Steam.viscosity(:,[1:2]),T);
mu_h2 = lerp([TPP.H2(:,1),TPP.H2(:,4)],T);

mu_gas = ( mu_h2*globalInputs.chemistry.X_H2*sqrt(globalInputs.chemistry.M_H2) + mu_steam*globalInputs.chemistry.X_Steam*sqrt(globalInputs.chemistry.M_Steam))...
    /(globalInputs.chemistry.X_H2*sqrt(globalInputs.chemistry.M_H2) + globalInputs.chemistry.X_Steam*sqrt(globalInputs.chemistry.M_Steam));
end

