function [ElDist, combMap] = updateElements(ElDist, globalInputs, Tdist, TPP,combMap)
%this function is responsible for updating all elements, it is called each
%time step to update the coefficient matrix for each subsequent temperature
%distribution.
N = globalInputs.program.N;
M = globalInputs.program.M;
r = globalInputs.program.radialNodes;
offset = globalInputs.program.offset;


for i = r+offset+1:-1:2
    for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding

        if strcmp(ElDist{i,j}.type,"slurry")
            [combMap,ElDist] = updateCombMap(ElDist, globalInputs, combMap,Tdist, i,j);
        end

        %check if element is product
        ElDist{i,j}.alpha = combMap(i,j);

        ElDist{i,j} = updateCoefficients(ElDist{i,j},Tdist,globalInputs,TPP,ElDist);

    end
end

end