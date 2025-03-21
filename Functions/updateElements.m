function ElDist = updateElements(ElDist, globalInputs, Tdist, TPP)
%this function is responsible for updating all elements, it is called each
%time step to update the coefficient matrix for each subsequent temperature
%distribution.
N = globalInputs.program.N;
M = globalInputs.program.M;
r = globalInputs.program.radialNodes;
offset = globalInputs.program.offset;


for i = r+offset+1:-1:2
    for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        ElDist{i,j} = updateCoefficients(ElDist{i,j},Tdist,globalInputs,TPP,ElDist);
    end
end

end