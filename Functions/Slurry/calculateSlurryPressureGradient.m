function ElVec = calculateSlurryPressureGradient(globalInputs,positionMap,ElVec,idx_s,d2u)
%Calculates the axial pressure gradient for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily

%calculate the new pressure gradient field
Pgrad_new = zeros(length(idx_s),1);

i = 1;
while i <= length(idx_s)
    neighbours = findNeighboursPosition(ElVec{idx_s(i)}.neighbours, positionMap, 1);

    %check for eastern and western neighbours
    if isempty(ElVec{neighbours(1)}) 
        Pgrad_west = 0;
        P_west = globalInputs.slurry.P;
    else
        Pgrad_west = ElVec{neighbours(1)}.Pgrad;
         P_west = ElVec{neighbours(1)}.P;
    end
    

    Pgrad_new(i) = -ElVec{idx_s(i)}.rho * (d2u(i)) * ElVec{idx_s(i)}.x + Pgrad_west;
    P_new(i) = P_west + ElVec{idx_s(i)}.x *Pgrad_new(i);
    i = i +1;
end

%update with new pressure gradient field
i = 1;
while i < length(idx_s)
    ElVec{idx_s(i)}.Pgrad = Pgrad_new(i);
    ElVec{idx_s(i)}.P = P_new(i);
    i = i +1;
end

end