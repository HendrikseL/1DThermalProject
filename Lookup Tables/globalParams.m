%This is the input struct for global parameters.

globalInputs = struct;

%program parameters
globalInputs.program.radialNodes = 3;
globalInputs.program.N = 3;
globalInputs.program.M = 1;
globalInputs.program.inputPadding = 2;
globalInputs.program.outputPadding = 2;
globalInputs.program.offset = 4; %offset between ambient and slurry

%Aluminum thermophysical properties @300K
globalInputs.aluminum.rho = 2701; %kg/m^3
globalInputs.aluminum.cp = 0.902; %kJ/kg K
globalInputs.aluminum.k = 237; %W/m K

%water thermophysical properties @300K
globalInputs.water.rho = 996.57; %kg/m^3
globalInputs.water.cp = 4.18;% kJ/kgK
globalInputs.water.k = 0.61450; %W/m K

%Initial temperature matrix (in celsius)
globalInputs.temperature.Ts = 80;
globalInputs.temperature.Tsc = 80;
globalInputs.temperature.Top = 80;
globalInputs.temperature.Tip = 80;
globalInputs.temperature.Tc = 20;
globalInputs.temperature.Ta = 21; %ambient temperature


%slurry inputs
globalInputs.slurry = struct;
globalInputs.slurry.rho = 1; %slurry density (kg/m^3)
globalInputs.slurry.Ts_in = 1; %slurry input tepperature (K)
globalInputs.slurry.massRatio = 1.3; % water/al mass ratio

%derive volume fraction and slurry density
globalInputs.aluminum.w = globalInputs.slurry.massRatio/(1+globalInputs.slurry.massRatio);
globalInputs.water.w = 1/ (1+ globalInputs.slurry.massRatio);

globalInputs.slurry.rho = globalInputs.water.rho*globalInputs.water.w + globalInputs.aluminum.rho*globalInputs.aluminum.w;
globalInputs.slurry.volumeFraction = (globalInputs.aluminum.w/globalInputs.aluminum.rho) / (globalInputs.aluminum.w/globalInputs.aluminum.rho + globalInputs.water.w/globalInputs.water.rho);
globalInputs.slurry.ms = 0.111; %kg/s

%screw physical parameters
globalInputs.screw = struct;
globalInputs.screw.h = (1.82/2) * 0.0254; %height of the blade (Blade D), m
globalInputs.screw.r0 = 2/2 * 0.0254; %initial blade radius, m
globalInputs.screw.r = globalInputs.screw.h - globalInputs.screw.r0 ; %radius of blade
globalInputs.screw.deltaR = globalInputs.screw.r/globalInputs.program.radialNodes;
globalInputs.screw.omega = 1; %rotational speed of the screw, rad/s
globalInputs.screw.p = 1; %pitch, m
globalInputs.screw.l = 50 * 0.0254; % length total?



globalInputs.HT.h_fpipe = 1900; %W/m^2K
globalInputs.HT.h_fgasket = 32000; %W/m^2K
