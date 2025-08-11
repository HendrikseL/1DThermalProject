%This is the input struct for global parameters.

globalInputs = struct;

%program parameters
globalInputs.program.radialNodes = 3;
globalInputs.program.N = 3;
globalInputs.program.M = 1;
globalInputs.program.inputPadding = 2;
globalInputs.program.outputPadding = 2;
globalInputs.program.offset = 4; %offset between ambient and slurry
globalInputs.program.maxIterations = 500;
globalInputs.program.timeStep = 1e-4;
globalInputs.program.writeOutput = 1; %flag for if write should be done
globalInputs.program.writeInterval = 10; %time steps between writes
globalInputs.program.outFile = "out.txt";
globalInputs.program.pOutFile = "pOut.txt";
globalInputs.program.pIterations = 3; %number of pressure loop iterations
globalInputs.program.alphaP = 0.5; %pressure underrelaxation factor

%Aluminum thermophysical properties @300K
globalInputs.aluminum.rho = 2701; %kg/m^3
% globalInputs.aluminum.cp = 0.902; %kJ/kg K
% globalInputs.aluminum.k = 237; %W/m K

globalInputs.al2o3.rho = 3950; %kg/m^3

%water thermophysical properties @300K
globalInputs.water.rho = 996.57; %kg/m^3
% globalInputs.water.cp = 4.18;% kJ/kgK
% globalInputs.water.k = 0.61450; %W/m K

%Initial temperature matrix (in celsius)
globalInputs.temperature.in.Ts = 80;
globalInputs.temperature.in.Tsc = 21.1111;
globalInputs.temperature.in.flange = 21.1111;
globalInputs.temperature.in.Tip = 21.1111;
globalInputs.temperature.in.Tc = 21.1111;

globalInputs.temperature.out.Ts = 21.1111;
globalInputs.temperature.out.Tsc = 21.1111;
globalInputs.temperature.out.flange = 21.1111;
globalInputs.temperature.out.Tip = 21.1111;
globalInputs.temperature.out.Tc = 21.1111;

globalInputs.temperature.Ta = 21.1111; %ambient temperature
globalInputs.temperature.Tig = 104.4 +273.15; %ignition temperature (K)

%slurry inputs
globalInputs.slurry.massRatio = 1.3; % water/al mass ratio

%derive volume fraction and slurry density
globalInputs.aluminum.w = 1/(1+globalInputs.slurry.massRatio); %mass fraction
globalInputs.water.w = globalInputs.slurry.massRatio/ (1+ globalInputs.slurry.massRatio); %mass fraction

globalInputs.slurry.rho = 1 / (globalInputs.water.w/globalInputs.water.rho + globalInputs.aluminum.w/globalInputs.aluminum.rho);
globalInputs.slurry.volumeFraction = (globalInputs.aluminum.w/globalInputs.aluminum.rho) / (globalInputs.aluminum.w/globalInputs.aluminum.rho + globalInputs.water.w/globalInputs.water.rho);
globalInputs.slurry.ms = 0.2553; %kg/s
globalInputs.slurry.Q = 1560310.37668; %W
globalInputs.slurry.P = 101325; %user specified inlet pressure (initial uniform pressure)
globalInputs.slurry.Pgrad = 0; %input pressure gradient

%inner pipe input parameters
globalInputs.innerPipe.ID = 1.86*0.0254; %inner pipe ID in m
globalInputs.innerPipe.OD = 2*0.0254; %inner pipe OD in m

%outer pipe input parameters
globalInputs.outerPipe.ID = 6.56*0.0254; %outer pipe ID in m
globalInputs.outerPipe.OD = 8*0.0254; %outer pipe OD in m

%screw physical parameters
globalInputs.screw = struct;
% globalInputs.screw.h = (1.82/2) * 0.0254; %height of the blade (Blade D), m
globalInputs.screw.r0 = 0.85/2 * 0.0254; %initial blade radius, m
globalInputs.screw.r = globalInputs.innerPipe.ID/2 - globalInputs.screw.r0 ; %radius of blade
globalInputs.screw.deltaR = globalInputs.screw.r/globalInputs.program.radialNodes;
globalInputs.screw.omega = 1; %rotational speed of the screw, rad/s
globalInputs.screw.lead = 1.75/0.0254; %lead, threads/m
globalInputs.screw.l = 96 * 0.0254; % length total?
globalInputs.screw.d = 0.85 *0.0254; %m
globalInputs.screw.bladeD= 1.82 * 0.0254; %m
globalInputs.screw.bladeT = 0.22*0.0254; %m

globalInputs.flange.h_fpipe = 1900; %W/m^2K
globalInputs.flange.h_fgasket = 32000; %W/m^2K
globalInputs.flange.D = 18.5*0.0254; %m
globalInputs.flange.t = 3.5*0.0254;%m

%coolant input parameters
globalInputs.coolant.m = 0; %38258*0.000125998; %kg/s
globalInputs.coolant.m_r = globalInputs.coolant.m * 0.9;
globalInputs.coolant.m_ax = globalInputs.coolant.m * 0.1;


%fin input parameters
globalInputs.fins.OD = 6.56*0.0254; %fins OD in m
globalInputs.fins.thickness = 0.0625*0.0254;
globalInputs.fins.spacing = 6 / 0.0254; %fins per meter (from fins per inch)

globalInputs.insulation.thickness = 3.5 * 0.0254; %insualtion thickness in meters, currently equal to the flange


%Chemistry Data (derived)
globalInputs.chemistry.M_H2 = 2.02; %g/mol
globalInputs.chemistry.M_Steam = 18.019; %g/mol
globalInputs.chemistry.M_Al2O3 = 101.959; %g/mol
%mass ratio
globalInputs.chemistry.mf_H2 = 0.11229; %g of h2/ g of al input
globalInputs.chemistry.mf_Steam = globalInputs.slurry.massRatio - 1; % Assumes full reaction
%mol ratio
globalInputs.chemistry.X_H2 = (globalInputs.chemistry.mf_H2/globalInputs.chemistry.M_H2)/((globalInputs.chemistry.mf_H2/globalInputs.chemistry.M_H2) + (globalInputs.chemistry.mf_Steam/globalInputs.chemistry.M_Steam));
globalInputs.chemistry.X_Steam = 1 - globalInputs.chemistry.X_H2;


%initial velocity (derived)
globalInputs.slurry.initialRho = calculateSlurryDensity(TPP,globalInputs,globalInputs.temperature.in.Ts+273.15,0,globalInputs.slurry.P);
globalInputs.slurry.initialV = zeros(globalInputs.program.radialNodes,2);
globalInputs.slurry.initialms = zeros(globalInputs.program.radialNodes,2);
for i = 5:1:4+globalInputs.program.radialNodes
   [globalInputs.slurry.initialV(i-4,:), globalInputs.slurry.initialms(i-4,:)]= initializeSlurryVelocity(globalInputs,i,globalInputs.slurry.initialRho);
end