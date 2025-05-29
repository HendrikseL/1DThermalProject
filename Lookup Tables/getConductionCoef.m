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
  
    case "water" %coolant conduction is used as this is the available data set for water with conduction heat transfer coefficients
        k = lerp(TPP.waterCoolantConduction(:,[1:2]),T);

    case "steam"
        k = lerp(TPP.Steam.conductivity(:,[1:2]),T);

    case "h2"
        k = lerp(TPP.H2(:,[1:2]),T);

    case "al2o3"
        k = lerp(TPP.Al2O3.conductivity(:,[1:2]),T);

    otherwise
        error("Selected material does not exist");
end
end