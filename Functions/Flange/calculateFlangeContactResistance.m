function cnt = calculateFlangeContactResistance(globalInputs,direction,position)
%calculates the flange contact resistance. contanct conduction coefficients
%are considered constant for this application.


%outer flange
h = 0;
A = 0;

switch direction
    case "gasket"
        h = globalInputs.flange.h_fgasket;
        A = pi/4 * (globalInputs.flange.D - globalInputs.outerPipe.OD);

    case "pipe"
        %outer
        if position(1) == 1 || position(1) == (4+ globalInputs.program.N*globalInputs.program.M)
            h = globalInputs.flange.h_fpipe;
            A = pi/4 * (globalInputs.outerPipe.OD - globalInputs.outerPipe.ID);
        %inner pipe
        else
            h = globalInputs.flange.h_fpipe;
            A = pi/4 * (globalInputs.innerPipe.OD - globalInputs.innerPipe.ID);
        end
end

cnt = 1/ (h * A);


end

