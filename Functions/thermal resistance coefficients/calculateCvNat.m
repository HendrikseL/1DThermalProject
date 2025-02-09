function cv_Nat = calculateCvNat(h, A)
%Calculates the natural convection resistance

%Input: h --> natural convection heat transfer coefficient
%        A --> Cross sectional area

cv_Nat = 1/(h*A);
end

