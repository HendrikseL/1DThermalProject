%This script reads in all thermophysical properties from their lookuptable
%files

TPP = struct;

%temp (c), k (Wm/K), cp(kJ/kgK)
TPP.aluminum = readmatrix("Aluminum_conductivity.csv",NumHeaderLines=1);

%temp (c), k (Wm/K)
TPP.hastelloyX = readmatrix("HastelloyX_conductivity.csv",NumHeaderLines=1);

%temp (c), k (Wm/K)
TPP.ss316 = readmatrix("SS316_conductivity.csv",NumHeaderLines=1);

%temp (c), k (Wm/K)
TPP.wool =readmatrix("RockWool_conductivity.csv",NumHeaderLines=1);

%temp (c), k (Wm/K), nu (m2/s), prandtl number
TPP.air = readmatrix("Air_Convection.csv",NumHeaderLines=1);

%temp (c), cp (kj/kgK), mu (Pa s)
TPP.water = readmatrix("Water_Convection.csv",NumHeaderLines=1);

%Temp (c), cp (kj/kgK), mu (Pa s)
TPP.waterCoolant = readmatrix("Water_Coolant_Convection.csv",NumHeaderLines=1);

%temp (c), k (Wm/K)
TPP.waterCoolantConduction = readmatrix("Water_Coolant_Conduction.csv",NumHeaderLines=1);