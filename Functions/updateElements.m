function ElDist = updateElements(ElDist, globalInputs, Tdist, TPP);
%this function is responsible for updating all elements, it is called each
%time step to update the coefficient matrix for each subsequent temperature
%distribution.
for k = 1:globalInputs.program.N:globalInputs.program.M*globalInputs.program.N
    for i = globalInputs.program.inputPadding+k:1:globalInputs.program.N+globalInputs.program.inputPadding+k-1
        for j = 1+globalInputs.program.offset:1:globalInputs.program.radialNodes+globalInputs.program.offset
            ElDist{j,i} = updateCoefficients(ElDist{j,i},Tdist,globalInputs,TPP, ElDist);
        end
    end
end

end