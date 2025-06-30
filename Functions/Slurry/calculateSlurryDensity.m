function rho = calculateSlurryDensity(TPP,globalInputs,T,alpha,P)
%calculates density of the slurry.

%reactants
rho_water = lerp([TPP.water(:,1),TPP.water(:,4)],T);
rho_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,4)],T);

rho_reactants = 1 / (globalInputs.water.w/rho_water + globalInputs.aluminum.w/rho_aluminum);

%products
rho_steam = lerp([TPP.Steam.density(:,1), TPP.Steam.density(:,2)],T);
rho_h2 = lerp([TPP.H2Density(:,1), TPP.H2Density(:,2)],T);

%correct with current pressure
Pref = 1e5;
P_steam = globalInputs.chemistry.X_Steam*P;
P_h2 = globalInputs.chemistry.X_H2*P;

rho_steam = (P_steam/Pref) * rho_steam;
rho_h2 = (P_h2/Pref) * rho_h2;


rho_products = globalInputs.chemistry.X_H2*rho_h2 + globalInputs.chemistry.X_Steam*rho_steam;

rho = alpha*rho_products + (1-alpha)*rho_reactants;
end

