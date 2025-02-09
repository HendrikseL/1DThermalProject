function [outputArg1,outputArg2] = calculateCdRadial(D2, D1, l, k)
%Calculates the axial radial conduction resistance

%Input: D2 --> outer diameter of the pipe
%       D1 --> inner diameter of the pipe
%       l --> length of the pipe
%       k --> conduction heat transfer coefficient

cd = ln(D2/D1) / (2*pi*l*k);
end

