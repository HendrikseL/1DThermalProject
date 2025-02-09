function cd = calculateCdAxial(x, k, A)
%Calculates the axial conduction resistance

%Input: x --> axial length of heat transfer
%       k --> condutction heat transfer coefficient
%       A --> Cross sectional area for heat transfer

cd = x/(k*A);
end

