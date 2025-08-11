function ElVec = updateElementVector(ElVec, slurryVel, slurryRho, slurryPgrad, slurryP,slurryPositionMap)
% updates the elements after the pressure-momentum loop is finished

%update elements in ElVec based on their position in slurryPositionMap
i = 1;
while i < length(slurryPositionMap)
    position = slurryPositionMap(i,3);
    %dont update boundary buffer nodes
    if ~isempty(ElVec{position})
        ElVec{position}.vel(1) = slurryVel(i);
        ElVec{position}.rho = slurryRho(i,1);
        ElVec{position}.P = slurryP(i);
        ElVec{position}.Pgrad = slurryPgrad(i);
    end
    i = i+1;
end

end

