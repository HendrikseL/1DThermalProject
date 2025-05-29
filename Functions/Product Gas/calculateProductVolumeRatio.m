function phi = calculateProductVolumeRatio(TPP, globalInputs, T)
%calulcates the volume ratio of gas to solids in the product mixture

    rho_steam = lerp(TPP.Steam.density(:,[1:2]),T);
    rho_h2 = lerp(TPP.H2Density(:,[1:2]),T);
    rho_gas = globalInputs.chemistry.X_H2*rho_h2 + globalInputs.chemistry.X_Steam*rho_steam;

    rho_al2o3 = globalInputs.al2o3.rho;

    c_w = globalInputs.chemistry.M_Al2O3/ (globalInputs.chemistry.M_Al2O3 + 3*globalInputs.chemistry.M_H2 + (globalInputs.slurry.massRatio-1)*3*globalInputs.chemistry.M_Steam);
    c_v = c_w*(rho_gas/rho_al2o3);

    phi = c_v/100;
end

