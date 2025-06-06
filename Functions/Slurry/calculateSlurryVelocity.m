function [vel, ms] = calculateSlurryVelocity(globalInputs,pos, rho,alpha)
%calculates slurry velocity from known density

%find radial position
radialPosition = globalInputs.program.radialNodes+5  - pos(1);

%calculate massflow
% [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,radialPosition);
ms_ax = globalInputs.slurry.ms * 1;
ms_r = globalInputs.slurry.ms * 0;

%turn total mass flow into the portion for that cell
%axial
radius = globalInputs.screw.d/2 + radialPosition*globalInputs.screw.deltaR;
A_ax = pi*(radius^2-(radius-globalInputs.screw.deltaR)^2);
A_axTotal =(pi/4)*(globalInputs.innerPipe.ID^2-globalInputs.screw.d^2);

ms_ax = ms_ax* (A_ax/A_axTotal);

%radial
 x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
A_r = x * 2*pi*radius;
A_rTotal = x*pi*globalInputs.innerPipe.ID;

ms_r = ms_r * (A_r/A_rTotal);

mf_reactants = 1;
%only considering the product gas portion of the products. we are assuming that the aluminum oxide does not accelerate like the gases do.
mf_products = globalInputs.chemistry.mf_H2 + globalInputs.chemistry.mf_Steam;

mf = mf_reactants*(1-alpha) + mf_products*alpha;

%axial velocity
vel(1) = (mf*ms_ax)/ (A_ax * rho);

%radial velocity
vel(2) = (ms_r*ms_ax) /(A_r*rho);

ms = [ms_ax, ms_r];
end

