function [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,node)
%breaks the mass flow down into the axial (ms_ax) and radial (ms_r)
%components based on screw geometry and radial position.

%Inputs: globalInputs --> global input struct, contains the screw physical
%           parameters and the slurry mass flow input
%        node --> Nodal position away from the screw wall, radialNode
%           position

    ms_ax = globalInputs.slurry.ms * (( ((node+1)*globalInputs.screw.deltaR)^2 - (node*globalInputs.screw.deltaR)^2)/...
        (globalInputs.innerPipe.ID^2 - globalInputs.screw.r0^2)) * 1/(sqrt(1 + ((2*pi*(node+1)*globalInputs.screw.deltaR)/ (1/globalInputs.screw.p))^2));

    ms_r = ms_ax * ((2*pi*((node+1)*globalInputs.screw.deltaR))/(1/globalInputs.screw.p));
        
end