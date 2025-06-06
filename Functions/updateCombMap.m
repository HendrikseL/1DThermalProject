function [combMap,ElDist] = updateCombMap(ElDist, globalInputs,combMap, Tdist,i,j)
%Convects combusted elements downstream
%if slurry is combusted, update the flag of its neighbours
%0 = no combustion
%1 = combusted, use products

%turn on alpha
    if (Tdist(i,j) > globalInputs.temperature.Tig) && (ElDist{i,j}.alpha > 0)
        %calculate how far products travel in 1 time step (moves at the
        %wave speed)
        %Calculate nodes travelled for slurry products
        [dist_int,ElDist{i,j}] = convectProductGas(ElDist{i,j},globalInputs);

        %convect prodctsS
        combMap(i,[j:j+dist_int(1)]) = 1;

        %convert products radially, order changes based on sign of
        %distance
        if dist_int(2) < 0
            range = i:i-dist_int(2);
        else
            range =i-dist_int(2):i;
        end
        combMap(range,j) = 1;


        %check if northern or southern neighbour are pipe or screw
        if strcmp(ElDist{i-1,j}.type,"innerPipe")
            combMap(i-1,j) = 1;
        elseif strcmp(ElDist{i+1,j}.type,"screw")
            combMap(i+1,j) = 1;
        end

        %turn off alpha, and respect that the product exists
    elseif (Tdist(i,j) < globalInputs.temperature.Tig) && (ElDist{i,j}.alpha > 0)
            [dist_int,ElDist{i,j}] = convectProductGas(ElDist{i,j},globalInputs);

            if dist_int(1) >= 1 || dist_int(2) >= 1
                ElDist{i,j}.alpha = 0;
                %products move to next cell
                ElDist{i,j+1}.alpha = 1;
                ElDist{i,j}.dist = [0 0];
            end

    end
end