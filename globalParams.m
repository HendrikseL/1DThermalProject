%This is the input struct for global parameters.

globalInputs = struct;

%program parameters
globalInputs.program.writeInterval = 1; %time steps between writes
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
globalInputs.temperature.in.Ts = 80;
globalInputs.temperature.in.Tsc = 80;
globalInputs.temperature.in.flange = 80;
globalInputs.temperature.in.Tip = 80;
globalInputs.temperature.in.Tc = 80;
globalInputs.temperature.in.Ts_up = globalInputs.temperature.in.Ts;
globalInputs.temperature.in.Tsc_up = globalInputs.temperature.in.Tsc;

globalInputs.temperature.out.Ts = 80;
globalInputs.temperature.out.Tsc = 80;
globalInputs.temperature.out.flange = 80;
globalInputs.temperature.out.Tip = 80;
globalInputs.temperature.out.Tc = 80;

globalInputs.temperature.Ta = 80; %ambient temperature

%slurry inputs
globalInputs.slurry = struct;
globalInputs.slurry.rho = 1; %slurry density (kg/m^3)
globalInputs.slurry.Ts_in = 1; %slurry input tepperature (K)
globalInputs.slurry.massRatio = 1.3; % water/al mass ratio

%derive volume fraction and slurry density
globalInputs.aluminum.w = globalInputs.slurry.massRatio/(1+globalInputs.slurry.massRatio); %mass fraction
globalInputs.water.w = 1/ (1+ globalInputs.slurry.massRatio); %mass fraction

globalInputs.slurry.rho = globalInputs.water.rho*globalInputs.water.w + globalInputs.aluminum.rho*globalInputs.aluminum.w;
globalInputs.slurry.volumeFraction = (globalInputs.aluminum.w/globalInputs.aluminum.rho) / (globalInputs.aluminum.w/globalInputs.aluminum.rho + globalInputs.water.w/globalInputs.water.rho);
globalInputs.slurry.ms = 0.2553; %kg/s

%screw physical parameters
globalInputs.screw = struct;
globalInputs.screw.h = (1.82/2) * 0.0254; %height of the blade (Blade D), m
globalInputs.screw.r0 = 0.85/2 * 0.0254; %initial blade radius, m
globalInputs.screw.r = globalInputs.screw.h - globalInputs.screw.r0 ; %radius of blade
globalInputs.screw.deltaR = globalInputs.screw.r/globalInputs.program.radialNodes;
globalInputs.screw.omega = 1; %rotational speed of the screw, rad/s
globalInputs.screw.p = 1.75/0.0254; %pitch, threads/m
globalInputs.screw.l = 50 * 0.0254; % length total?
globalInputs.screw.d = 0.85 *0.0254; %m
globalInputs.screw.bladeD= 1.82 * 0.0254; %m
globalInputs.screw.bladeT = 0.22*0.0254; %m

globalInputs.flange.h_fpipe = 1900; %W/m^2K
globalInputs.flange.h_fgasket = 32000; %W/m^2K
globalInputs.flange.D = 18.5*0.0254; %m
globalInputs.flange.t = 3.5*0.0154;%m

%coolant input parameters
globalInputs.coolant.m = 4.8204269; %kg/s
globalInputs.coolant.m_r = globalInputs.coolant.m * 0.9;
globalInputs.coolant.m_ax = globalInputs.coolant.m * 0.1;

%inner pipe input parameters
globalInputs.innerPipe.ID = 0.047244; %inner pipe ID in m
globalInputs.innerPipe.OD = 0.0508; %inner pipe OD in m

%outer pipe input parameters
globalInputs.outerPipe.ID = 0.166624; %outer pipe ID in m
globalInputs.outerPipe.OD = 0.2032; %outer pipe OD in m

%fin input parameters
globalInputs.fins.OD = 0.166624; %6.75 ins, but right now it is equal to 6.56 as the fins seem to be too long.
globalInputs.fins.thickness = 0.0015875;
globalInputs.fins.spacing = 6 / 0.0254; %fins per meter (from fins per inch)

globalInputs.insulation.thickness = 3.5 * 0.0254; %insualtion thickness in meters, currently equal to the flange