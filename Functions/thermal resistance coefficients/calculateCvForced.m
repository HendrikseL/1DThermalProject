function cv_Forced = calculateCvForced(h, A)
%Calculates the natural convection resistance

%Input: h --> convection heat transfer coefficient
%       A --> Cross sectional area

cv_Forced = 1/(h*A);
end

