function cnt = calculateFlangeContactResistance(globalInputs,direction,position)
%calculates the flange contact resistance. contanct conduction coefficients
%are considered constant for this application.


%outer flange
h = 0;
A = 0;

switch direction
    case "gasket"
        h = globalInputs.flange.h_fgasket;
        A = pi/4 * (globalInputs.flange.D^2 - globalInputs.outerPipe.OD^2);

    case "pipe"
        %outer
        if position(2) == 1 || position(2) == (4+ globalInputs.program.N*globalInputs.program.M)
            h = globalInputs.flange.h_fpipe;
            A = pi/4 * (globalInputs.outerPipe.OD^2 - globalInputs.outerPipe.ID^2);
        %inner pipe
        else
            h = globalInputs.flange.h_fpipe;
            A = pi/4 * (globalInputs.innerPipe.OD^2 - globalInputs.innerPipe.ID^2);
        end
end

cnt = 1/ (h * A);


end

