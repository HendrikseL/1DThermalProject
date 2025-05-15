%This script reads in all thermophysical properties from their lookuptable
%files
%All tables are in celsius, and so are changed to kelvin as the first step

TPP = struct;

%temp (c), k (W/m K), cp(kJ/kgK)
TPP.aluminum = readmatrix("Aluminum_conductivity.csv",NumHeaderLines=1);
TPP.aluminum(:,1) = TPP.aluminum(:,1) + 273.15;

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
TPP.water = readmatrix("Water_Coolant_Convection_2.csv",NumHeaderLines=1);
TPP.water(:,1) = TPP.water(:,1) + 273.15;
TPP.water(:,2) = TPP.water(:,2)*1000; %converting to J/kgK

%Temp (c), cp (kj/kgK), mu (Pa s) (Coolant Water)
TPP.waterCoolant = readmatrix("Water_Coolant_Convection_2.csv",NumHeaderLines=1);
TPP.waterCoolant(:,1) = TPP.waterCoolant(:,1) + 273.15;
TPP.waterCoolant(:,2) = TPP.waterCoolant(:,2)*1000; %converting to J/kgK

%temp (c), k (W/m K)
TPP.waterCoolantConduction = readmatrix("Water_Coolant_Conduction.csv",NumHeaderLines=1);
TPP.waterCoolantConduction(:,1) = TPP.waterCoolantConduction(:,1) + 273.15;