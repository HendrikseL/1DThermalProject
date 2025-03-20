function [cd_fin, k_fin] = calculateFinsConductionResistance(TPP,globalInputs,T,direction)
%Calculate the thermal conduction resistance of the flange

%Input: GlobalVariables and thermophysical properties
%       T -> desired temperature

k_fin =getConductionCoef(TPP,T,"ss316");

x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

%find distance from wall
D2 = globalInputs.fins.OD;
D1 = globalInputs.innerPipe.ID;

switch direction

    case "axial"
        %integer number of fins per area
        totalFins = round(x * globalInputs.fins.spacing);

        %front and back area
        fA =  (pi/4) * (D2^2 - D1^2);

        %two faces per fin
        A = 2* totalFins * fA;
        
        cd_fin = (x) /(k_fin *A);

    case "radial"
        %assuming l is local length, represented here by x
        cd_fin = (log((D2)/D1)) / (2*pi*x*k_fin);
end

end



