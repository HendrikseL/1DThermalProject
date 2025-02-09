%This is the input struct for global parameters.

globalInputs = struct;

%program parameters
globalInputs.program.radialNodes = 3;
globalInputs.program.N = 3;
globalInputs.program.M = 1;

%slurry inputs
globalInputs.slurry = struct;
globalInputs.slurry.rho = 1; %slurry density (kg/m^3)
globalInputs.slurry.Ts_in = 1; %slurry input tepperature (K)


%screw physical parameters
globalInputs.screw = struct;
globalInputs.screw.h = (1.82/2) * 0.0254; %height of the blade (Blade D), m
globalInputs.screw.r0 = 1; %initial blade radius, m
globalInputs.screw.omega = 1; %rotational speed of the screw, m

%Initial temperature matrix
globalInputs.T_init = 80* ones(8,7);
globalInputs.T_init(1,3) = 20;
globalInputs.T_init(1,5) = 20;