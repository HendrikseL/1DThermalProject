function [slurryP, slurryPgrad] = calculateSlurryPressure(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryP,slurryRho)
%Calculates the axial pressure field for the slurry, implicitly
   
%calculates a coefficient matrix for the slurry velocity
[AP , bP] = constructPressureCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryP,slurryRho);

slurryP = (AP\bP');

%calculate pressure gradient
slurryPgrad = zeros(length(slurryP),1);

i = 1;
while isempty(ElVec{slurryPositionMap(i,3)})
    slurryPgrad(i) = globalInputs.slurry.Pgrad;
    i = i+1;
end

while ~isempty(ElVec{slurryPositionMap(i,3)})
    neighbours = findNeighboursPosition(ElVec{slurryPositionMap(i,3)}.neighbours,slurryPositionMap,3);

    slurryPgrad(i) = (slurryP(neighbours(1)) - slurryP(neighbours(3)))/ElVec{slurryPositionMap(i,3)}.x^2;

    i = i+1;
end

end
