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
        %0 = no combustion
        %1 = combusted, use products
        if strcmp(ElDist{i,j}.type,"slurry") && (ElDist{i,j}.alpha > 0)
            %calculate how far products travel in 1 time step (moves at the
            %wave speed)
            %Calculate nodes travelled for slurry products
            ElDist{i,j}.dist = ElDist{i,j}.dist + (ElDist{i,j}.vel*globalInputs.program.timeStep);
            %round distance to integer corresponding to nodes travelled
            dist_int(1) = round(ElDist{i,j}.dist(1)/ElDist{i,j}.x);
            dist_int(2) = round(ElDist{i,j}.dist(2)/globalInputs.screw.deltaR);

            %ensure maximum radial distance is not exceeded
            dist_rMax = globalInputs.program.radialNodes - (globalInputs.program.radialNodes + 5 -ElDist{i,j}.pos(1));
            if dist_int(2) > dist_rMax
                dist_int(2) = dist_rMax;
            end

            %convect prodctsS
            combMap(i,[j:j+dist_int(1)]) = 1;
            combMap([i-dist_int(2):i],j) = 1;


            %check if northern or southern neighbour are pipe or screw
            if strcmp(ElDist{i-1,j}.type,"innerPipe")
                combMap(i-1,j) = 1;
            elseif strcmp(ElDist{i+1,j}.type,"screw")
                combMap(i+1,j) = 1;
            end
        end

        %check if element is combusted
        ElDist{i,j}.alpha = combMap(i,j);

        ElDist{i,j} = updateCoefficients(ElDist{i,j},Tdist,globalInputs,TPP,ElDist);

        %if element is now combusted update the combustion map
        % combMap(i,j) = ElDist{i,j}.COMBUSTION;

    end
end

end