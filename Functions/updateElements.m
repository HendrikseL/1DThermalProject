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

        %if slurry is combusted, update the flag of its neighbours
        if strcmp(ElDist{i,j}.type,"slurry") && ElDist{i,j}.COMBUSTION == 1
            %downstream neighbours
            combMap(i,[j:end]) = 1;

            %check if northern or southern neighbour are pipe or screw
            if strcmp(ElDist{i-1,j}.type,"innerPipe")
                combMap(i-1,j) = 1;
            elseif strcmp(ElDist{i+1,j}.type,"screw")
                combMap(i+1,j) = 1;
            end
        end

        %check if element is combusted
        ElDist{i,j}.COMBUSTION = combMap(i,j);

        ElDist{i,j} = updateCoefficients(ElDist{i,j},Tdist,globalInputs,TPP,ElDist);

        %if element is now combusted update the combustion map
        combMap(i,j) = ElDist{i,j}.COMBUSTION;

    end
end

end