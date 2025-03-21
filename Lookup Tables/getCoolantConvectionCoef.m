function h = getCoolantConvectionCoef(TPP,globalInputs,T)

if T < 100
    mu_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,3)],T);
    cp_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,2)],T);
    k_water = lerp([TPP.waterCoolantConduction(:,1),TPP.CoolantConduction(:,2)],T);
else
    mu_water = TPP.waterCoolant(end,3);
    cp_water = TPP.waterCoolant(end,2);
    k_water = TPP.waterCoolantConduction(end,2);
end


%Reynolds number and Prandtl number
Pr = (cp_water * mu_water) / k_water;

Red = (2*globalInputs.slurry.m)/(globalInputs.screw.r*pi*mu_water);

%single fin in transfer flow
Nu = 0.011*Red^0.96;

%getting characteristic length
l = globalInputs.screw.l / (globalInputs.program.N * globalInputs.program.M);

h = (Nu*k_slurry) / l;

end

