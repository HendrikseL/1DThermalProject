%units tests for the following scripts:
%   getConductionCoef.m
%   getForcedConvectionCoef.m
%   getNaturalConvectionCoef.m


%%test 1: conduction coeficients
clear
createThermophysicaProperties;

T = 100; %c
tol = 1e-3;

k = getConductionCoef(TPP,T,"hastelloyX");
assert(abs(k -11.2)<tol);

k = getConductionCoef(TPP,T,"ss316");
assert(abs(k -0.1505)<tol);

k = getConductionCoef(TPP,T,"wool");
assert(abs(k -0.0455)<tol);

k = getConductionCoef(TPP,T,"aluminum");
assert(abs(k -239.19)<tol);

k = getConductionCoef(TPP,T,"water");
assert(abs(k -4.194)<tol);

%%test 2:
clear
globalParams;
createThermophysicaProperties;

T = 100; %c
tol = 1e-3;

k_al = getConductionCoef(TPP,T,"aluminum");
k_water = getConductionCoef(TPP,T,"water");

k_slurry = globalInputs.slurry.volumeFraction*k_al + (1-globalInputs.slurry.volumeFraction)*k_water;

h = getForcedConvectionCoef(TPP,globalInputs,T,k_slurry);
assert(abs(h-58.434)<tol);


