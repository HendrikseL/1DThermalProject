function k_gas = calculateGasConductionCoef(globalInputs,k_steam, k_h2)
%caclulates the conduction coefficient for product gasses. Only considers
%the steam and h2 values

%binary mixture of gasses: 
%Udoetok, Thermal conductivity of binary mixtures of gases, Frontiers in
%Heat and Mass Transfer
k_gas = 1/2 * ((k_h2*k_steam)/ (k_steam*globalInputs.chemistry.X_H2 + k_h2*globalInputs.chemistry.X_Steam)) + ...
    1/2* (k_h2 *globalInputs.chemistry.X_H2 + k_steam*globalInputs.chemistry.X_Steam);
end

