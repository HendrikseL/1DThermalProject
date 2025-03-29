function [A2, b2, A3, b3] = constructFlangeMatrices(Tdist, TPP, globalInputs, cde)
%this function outputs A and b for matrix equation Ax = b
%In this case it is for the flange matrices. M.2 A and b will have
%subscript 2 and M.3 will have subscript 3. These matrices are meant to
%solve for flange temperatures

endIdx = 4+globalInputs.program.N*globalInputs.program.M;

%natural convection resistances
cv_nat_f1 = calculateNaturalConvectionResistance(TPP,globalInputs,Tdist(1,1),"flange",[1,1]);
cv_nat_f2 = calculateNaturalConvectionResistance(TPP,globalInputs,Tdist(1,2),"flange",[1,2]);
cv_nat_f3 = calculateNaturalConvectionResistance(TPP,globalInputs,Tdist(1,endIdx-1),"flange",[1,endIdx-1]);
cv_nat_f4 = calculateNaturalConvectionResistance(TPP,globalInputs,Tdist(1,endIdx),"flange",[1,endIdx]);


A2 = [ (1/cde(1) + 1/cde(5) + 1/cv_nat_f1), -1/cde(5);
           -1/cde(5), (1/cde(2) + 1/cde(5) + 1/cv_nat_f2)]; 

b2 = [globalInputs.temperature.in.Tip/cde(1) + globalInputs.temperature.Ta/cv_nat_f1;
        Tdist(2,3)/cde(2) + globalInputs.temperature.Ta/cv_nat_f2];


A3 = [ (1/cde(3) + 1/cde(6) + 1/cv_nat_f3), -1/cde(6);
           -1/cde(6), (1/cde(4) + 1/cde(6) + 1/cv_nat_f4)]; 

b3 = [Tdist(2,endIdx-2)/cde(3) + globalInputs.temperature.Ta/cv_nat_f3;
        globalInputs.temperature.out.Tip/cde(4) + globalInputs.temperature.Ta/cv_nat_f4];

end

