function [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,radialPosition)
%breaks the mass flow down into the axial (ms_ax) and radial (ms_r)
%components based on screw geometry and radial position.

%Inputs: globalInputs --> global input struct, contains the screw physical
%           parameters and the slurry mass flow input
%        radialPosition --> Nodal position away from the screw wall, radialNode
%           position

pitch = 1/globalInputs.screw.lead;
radius = globalInputs.screw.d/2 + radialPosition*globalInputs.screw.deltaR;
path = (2*pi*radius)/pitch;

ms_ax = globalInputs.slurry.ms* ((radius^2-(radius-globalInputs.screw.deltaR)^2)/(globalInputs.screw.bladeD^2 - globalInputs.screw.d^2)) *(1/(1+path^2));
ms_r = ms_ax*path;
        
end