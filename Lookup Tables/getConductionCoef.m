%interpolates through materials list to find conduction coefficient at
%desired temperature
%Inputs
%   TPP - thermophysical properties
%   T - desired temperature in celsius
%   material - material desired
function k = getConductionCoef(TPP, T, material)
    switch material
    
        case "hasteloyX"
            k = lerp(TPP.hastelloyX(:,[1:2]),T);
        case "ss316"
            k = lerp(TPP.ss316(:,[1:2]),T);
        case "wool"
            k = lerp(TPP.wool(:,[1:2]),T);
        case "aluminum"
            k = lerp(TPP.aluminum(:,[1:2]),T);
        case "water"
            %fix me. needs new data set for water under pressure
            k = lerp(TPP.waterCoolantConduction(:,[1:2]),T);
        otherwise
            error("Selected material does not exist");
    end
end