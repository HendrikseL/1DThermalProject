function drho = calculateSlurryDensityGradient(TPP,globalInputs,positionMap,ElVec,Tvec,idx_s)

drho = zeros(length(idx_s),1);

i = 1;
while i <= length(idx_s)

    %Calculates the axial velocity gradients for the slurry. i is current node.
    neighbours = findNeighboursPosition(ElVec{idx_s(i)}.neighbours, positionMap, 4);
    
    %check for eastern and western neighbours
    if isempty(ElVec{neighbours(1)})
        rho_west = calculateSlurryDensity(TPP,globalInputs,Tvec(neighbours(1)),ElVec{idx_s(i)}.alpha,ElVec{idx_s(i)}.P);
    else
        rho_west = ElVec{neighbours(1)}.rho;
    end
    
    
    
    %first derivative
    drho(i) = (ElVec{idx_s(i)}.rho - rho_west) / ElVec{idx_s(i)}.x;

    i = i +1;
end
end

