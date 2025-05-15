function rho = calculateSlurryDensity(TPP,globalInputs,T,alpha)
    %calculates density of the slurry. Can handle combustion.

    switch alpha
        %combustion
        case 1
            %do nothing
        case 0
            if T < TPP.water(1,1)
                rho_water = TPP.water(1,4);
            elseif T> TPP.water(end,1)
                rho_water = TPP.water(end,4);
            else
                rho_water = lerp([TPP.water(:,1),TPP.water(:,4)],T);
            end

            if T < TPP.aluminum(1,1)
                rho_aluminum = TPP.aluminum(1,4);
            elseif T > TPP.aluminum(end,1)
                rho_aluminum = TPP.aluminum(end,4);
            else
                rho_aluminum = lerp([TPP.aluminum(:,1),TPP.aluminum(:,4)],T);
            end

            rho = 1 / (globalInputs.water.w/rho_water + globalInputs.aluminum.w/rho_aluminum);
    end
end

