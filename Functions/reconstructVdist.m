function Vdist = reconstructVdist(globalInputs, slurryVel,slurryPositionMap)
%similar to reconstruct Tdist, but this function is only used for
%outputting a pressure field within the slurry.

Vdist = zeros(globalInputs.program.radialNodes+5,globalInputs.program.N*globalInputs.program.M+4);


i = 1;
while i <= length(slurryPositionMap)
    %slurryP is used to ensure boundary pressure are reconstructed
    Vdist(slurryPositionMap(i,1),slurryPositionMap(i,2)) = slurryVel(i);

    i = i +1;
end
end

