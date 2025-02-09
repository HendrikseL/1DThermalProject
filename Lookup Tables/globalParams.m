%This is the input struct for global parameters.

globalInputs = struct;

globalInputs.screw = struct;
globalInputs.screw.h = (1.82/2) * 0.0254; %height of the blade (Blade D), m
globalInputs.screw.r0 = 1; %initial blade radius
globalInputs.screw.