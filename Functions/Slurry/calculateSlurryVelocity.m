function vel = calculateSlurryVelocity(globalInputs,pos, rho, alpha)
%calculates slurry velocity from known density

%find radial position
radialPosition = globalInputs.program.radialNodes+5  - pos(1);

%calculate massflow
% [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,radialPosition);
ms_ax = globalInputs.slurry.ms * 0.5;
ms_r = globalInputs.slurry.ms * 0.5;

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

%no combustion
if alpha == 0
    %axial velocity
    vel(1) = ms_ax/ (A_ax * rho);

    %radial velocity
    vel(2) = ms_r /(A_r*rho);
else
    %do nothing
end

end

