function rho = calculateSlurryDensity(TPP,globalInputs,T,alpha)
    %calculates density of the slurry. Can handle combustion.

    switch alpha
        %combustion
        case 1
            %do nothing
        case 0
            rho_water = lerp([TPP.water(:,1),TPP.water(:,4)],T);
            rho_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,4)],T);

            rho = 1 / (globalInputs.water.w/rho_water + globalInputs.aluminum.w/rho_aluminum);
    end
end

