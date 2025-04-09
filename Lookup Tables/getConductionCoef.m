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
    case "water" %cooan conduction is used as this is the available data set for water with conduction heat transfer coefficients
        if T < TPP.waterCoolantConduction(1,1)
            k = TPP.waterCoolantConduction(1,2);
        elseif T > TPP.waterCoolantConduction(end,1)
            k =TPP.waterCoolantConduction(end,2);
        else
            k = lerp(TPP.waterCoolantConduction(:,[1:2]),T);
        end
    otherwise
        error("Selected material does not exist");
end
end