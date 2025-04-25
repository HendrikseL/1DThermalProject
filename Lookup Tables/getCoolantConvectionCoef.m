function h = getCoolantConvectionCoef(TPP,globalInputs,T)

if T < TPP.waterCoolant(end,1)
    mu_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,3)],T);
    cp_water = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,2)],T);
    k_water = lerp([TPP.waterCoolantConduction(:,1),TPP.waterCoolantConduction(:,2)],T);
else
    mu_water = TPP.waterCoolant(end,3);
    cp_water = TPP.waterCoolant(end,2);
    k_water = TPP.waterCoolantConduction(end,2);
end


%Reynolds number and Prandtl number
Pr = (cp_water * mu_water) / k_water;

%calculating reynolds number
t=1/globalInputs.fins.spacing;
h = (globalInputs.fins.OD-globalInputs.innerPipe.OD)/2;
%hydraulic diameter
D = 4*(t-globalInputs.fins.thickness)*h*(2*h+globalInputs.innerPipe.OD) / (pi*globalInputs.innerPipe.OD*t + globalInputs.fins.thickness*2*h);

Red = (4*globalInputs.coolant.m)/(D*pi*mu_water);

%Spiral Finned H-X
Nu_1 = 0.138*(t/globalInputs.innerPipe.OD)^0.168 * (h/globalInputs.innerPipe.OD)^(-0.132) * Red^0.68 * Pr^(1/3);

%Single Solid Fin
Nu_2 = 0.038*Red^0.8*Pr^0.4;

%averag the two assumed flow types
Nu = (Nu_1 + Nu_2) /2;

h = (Nu*k_water) / D;

end

