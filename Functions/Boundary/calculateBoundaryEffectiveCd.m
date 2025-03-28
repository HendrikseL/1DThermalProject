function cde = calculateBoundaryEffectiveCd(globalInputs, Tdist, TPP)
%Cde is a matrix of effective conduction coefficients for the flanges
%in order of index:
%       1:cde1,2:cde2,3:cde3,4:cde4,5:cde12,6:cde34

%positions of f3 and f4
posF3 =[1, 3+globalInputs.program.N*globalInputs.program.M];
posF4 =[1, 4+ globalInputs.program.N*globalInputs.program.M];

cdf1 = calculateFlangeConductionResistance(TPP,globalInputs,Tdist(1,1),"axial",[1,1]);
cdf2 = calculateFlangeConductionResistance(TPP,globalInputs,Tdist(1,2),"axial",[1,2]);
cdf3 = calculateFlangeConductionResistance(TPP,globalInputs,Tdist(posF3(1),posF3(2)),"axial",posF3);
cdf4 = calculateFlangeConductionResistance(TPP,globalInputs,Tdist(posF4(1),posF4(2)),"axial",posF4);

cde(1) = cdf1 + calculateFlangeContactResistance(globalInputs,"pipe",[1,1]);
cde(2) = cdf2 + calculateFlangeContactResistance(globalInputs,"pipe",[1,2]);

cde(3) =  cdf3 + calculateFlangeContactResistance(globalInputs,"pipe",posF3);
cde(4) =  cdf4 + calculateFlangeContactResistance(globalInputs,"pipe",posF4);

cde(5) = cdf1 + calculateFlangeContactResistance(globalInputs,"gasket",[1,1]) + cdf2;
cde(6) = cdf3 + calculateFlangeContactResistance(globalInputs,"gasket",posF4) + cdf4;

end

