%interpolates through materials list to find conduction coefficient at
%desired temperature
%Inputs
%   TPP - thermophysical properties
%   T - desired temperature in celsius
%   material - material desired
function k = getConductionCoef(TPP, T, material)
switch material

    case "hasteloyX"
        if T < TPP.hastelloyX(1,1)
            k = TPP.hastelloyX(1,2);
        elseif T > TPP.hastelloyX(end,1)
            k =TPP.hastelloyX(end,2);
        else
            k = lerp(TPP.hastelloyX(:,[1:2]),T);
        end
    case "ss316"
        if T < TPP.ss316(1,1)
            k = TPP.ss316(1,2);
        elseif T > TPP.ss316(end,1)
            k =TPP.ss316(end,2);
        else
            k = lerp(TPP.ss316(:,[1:2]),T);
        end
    case "wool"
        if T < TPP.wool(1,1)
            k = TPP.wool(1,2);
        elseif T > TPP.wool(end,1)
            k =TPP.wool(end,2);
        else
            k = lerp(TPP.wool(:,[1:2]),T);
        end
    case "aluminum"
        if T < TPP.aluminum(1,1)
            k = TPP.aluminum(1,2);
        elseif T > TPP.aluminum(end,1)
            k =TPP.aluminum(end,2);
        else
            k = lerp(TPP.aluminum(:,[1:2]),T);
        end
    case "water"
        if T < TPP.water(1,1)
            k = TPP.water(1,2);
        elseif T > TPP.water(end,1)
            k =TPP.water(end,2);
        else
            k = lerp(TPP.water(:,[1:2]),T);
        end
    otherwise
        error("Selected material does not exist");
end
end