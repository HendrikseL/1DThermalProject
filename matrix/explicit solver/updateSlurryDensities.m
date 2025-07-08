function slurryRho = updateSlurryDensities(globalInputs,TPP,slurryRho,slurryP,ElVec,slurryTvec,slurryPositionMap)
%updates all densitys using new pressure field and old temperature field.

i = 1;
while isempty(ElVec{slurryPositionMap(i,3)})
    slurryRho(i,1) = calculateSlurryDensity(TPP,globalInputs,slurryTvec(i),0,slurryP(i));
    i = i+1;
end

while ~isempty(ElVec{slurryPositionMap(i,3)})
    slurryRho(i,1) = calculateSlurryDensity(TPP,globalInputs,slurryTvec(i),ElVec{slurryPositionMap(i,3)}.alpha,slurryP(i));

    i = i +1;
end

while i <= length(slurryPositionMap(:,1))
    neighbours = findNeighboursPosition([slurryPositionMap(i,1),slurryPositionMap(i,2)-1],slurryPositionMap,1);

    slurryRho(i,1) =  calculateSlurryDensity(TPP,globalInputs,slurryTvec(i),ElVec{slurryPositionMap(neighbours(1),3)}.alpha,slurryP(i));
    i = i +1;
end

