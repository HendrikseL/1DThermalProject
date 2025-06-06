function [dist_int,ElDist] = convectProductGas(ElDist,globalInputs)
%Convects product gas downstream
        ElDist.dist(1) = ElDist.dist(1) + (ElDist.vel(1)*globalInputs.program.timeStep);
        ElDist.dist(2) = ElDist.dist(2) + (ElDist.vel(2)*globalInputs.program.timeStep); 

        %round distance to integer corresponding to nodes travelled
        dist_int(1) = round(ElDist.dist(1)/ElDist.x);
        dist_int(2) = round(ElDist.dist(2)/globalInputs.screw.deltaR);

        %ensure maximum axial distance is not exceeded
        dist_axMax = globalInputs.program.N*globalInputs.program.M+4 -ElDist.pos(2);
        if abs(dist_int(1)) > dist_axMax
            dist_int(1) =  sign(dist_int(1))*dist_axMax;
        end
        %ensure maximum radial distance is not exceeded
        dist_rMax = abs(globalInputs.program.radialNodes - (globalInputs.program.radialNodes + 5 -ElDist.pos(1)));
        if abs(dist_int(2)) > dist_rMax
            dist_int(2) = sign(dist_int(2))*dist_rMax;
        end
end

