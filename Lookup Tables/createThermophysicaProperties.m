%This script reads in all thermophysical properties from their lookuptable
%files
%All tables are in celsius, and so are changed to kelvin as the first step

TPP = struct;

%temp (c), k (W/m K), cp(kJ/kgK)
TPP.aluminum = readmatrix("Aluminum_conductivity.csv",NumHeaderLines=1);
TPP.aluminum(:,1) = TPP.aluminum(:,1) + 273.15;
TPP.aluminum(:,3) = TPP.aluminum(:,3) *1000;

%temp (c), k (W/m K)
TPP.hastelloyX = readmatrix("HastelloyX_conductivity.csv",NumHeaderLines=1);
TPP.hastelloyX(:,1) = TPP.hastelloyX(:,1) + 273.15;

TPP.hastelloyX_c = readmatrix("HastelloyX_heatCap.csv",NumHeaderLines=1);
TPP.hastelloyX_c(:,1) = TPP.hastelloyX_c(:,1) + 273.15;

%temp (c), k (W/m K)
TPP.ss316 = readmatrix("SS316_conductivity.csv",NumHeaderLines=1);
TPP.ss316(:,1) = TPP.ss316(:,1) + 273.15;

TPP.ss316_c = readmatrix("SS316_heatCap.csv",NumHeaderLines=1);
TPP.ss316_c(:,1) = TPP.ss316_c(:,1) + 273.15;

%temp (c), k (W/m K)
TPP.wool =readmatrix("RockWool_conductivity.csv",NumHeaderLines=1);
TPP.wool(:,1) = TPP.wool(:,1) + 273.15;

%temp (c), k (W/m K), nu (m2/s), prandtl number
TPP.air = readmatrix("Air_Convection.csv",NumHeaderLines=1);
TPP.air(:,1) = TPP.air(:,1) + 273.15;

%temp (c), cp (kj/kgK), mu (Pa s) (Slurry Water)
TPP.water = readmatrix("Water_properties.csv",NumHeaderLines=1);
TPP.water(:,1) = TPP.water(:,1) + 273.15;
TPP.water(:,2) = TPP.water(:,2)*1000; %converting to J/kgK

%Temp (c), cp (kj/kgK), mu (Pa s) (Coolant Water)
%seperate from slurry water to allow for a change in coolant easily
TPP.waterCoolant = readmatrix("Water_properties.csv",NumHeaderLines=1);
TPP.waterCoolant(:,1) = TPP.waterCoolant(:,1) + 273.15;
TPP.waterCoolant(:,2) = TPP.waterCoolant(:,2)*1000; %converting to J/kgK

%temp (c), k (W/m K)
TPP.waterCoolantConduction = readmatrix("Water_Coolant_Conduction.csv",NumHeaderLines=1);
TPP.waterCoolantConduction(:,1) = TPP.waterCoolantConduction(:,1) + 273.15;


%H2 Properties
%[Engineering Toolbox, Hydrogen - density and specific weight vs. temperature, T[C] rho[kg/m3]]
%Pref = 1e5 Pa
TPP.H2 = readmatrix("H2_properties.csv",NumHeaderLines=1);
TPP.H2(:,1) = TPP.H2(:,1) + 273.15;
TPP.H2(:,3) = TPP.H2(:,3)*1000;

TPP.H2Density = readmatrix("H2_density.csv",NumHeaderLines=1);
TPP.H2Density(:,1) = TPP.H2Density(:,1) + 273.15;

%Steam Properties
%[Engineering Toolbox, Dry air and water vapor - Density and Specific Volume vs. temperature, T[C] rho[kg/m3]]
%Pref = 1e5; Pa
TPP.Steam.density = readmatrix("Steam_Density.csv",NumHeaderLines=1);
TPP.Steam.density(:,1) = TPP.Steam.density(:,1) + 273.15;

TPP.Steam.conductivity = readmatrix("Steam_conductivity.csv",NumHeaderLines=1);
TPP.Steam.conductivity(:,1) = TPP.Steam.conductivity(:,1) +273.15;

TPP.Steam.viscosity = readmatrix("Steam_viscosity.csv",NumHeaderLines=1);
TPP.Steam.viscosity(:,1) = TPP.Steam.viscosity(:,1) + 273.15;

TPP.Steam.heatCap = readmatrix("Steam_heatCap.csv",NumHeaderLines=1);
TPP.Steam.heatCap(:,1) = TPP.Steam.heatCap(:,1) + 273.15;
TPP.Steam.heatCap(:,2) = TPP.Steam.heatCap(:,2)*1000;

%Al2O3 Properties
TPP.Al2O3.heatCap = readmatrix("Al2O3_heatCap.csv");
TPP.Al2O3.heatCap(:,1) = TPP.Al2O3.heatCap(:,1) + 273.15;

TPP.Al2O3.conductivity = readmatrix("Al2O3_conductivity.csv");
TPP.Al2O3.conductivity(:,1) = TPP.Al2O3.conductivity(:,1) + 273.15;
