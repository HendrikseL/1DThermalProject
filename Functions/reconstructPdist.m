function Pdist = reconstructPdist(globalInputs, ElVec,positionMap)
%similar to reconstruct Tdist, but this function is only used for
%outputting a pressure field within the slurry.

idx_s = findSlurryNodesIndex(ElVec,globalInputs);
Pdist = zeros(globalInputs.program.N*globalInputs.program.M+4,globalInputs.program.radialNodes+5);


i = 1;
while i <= length(idx_s)
    Pdist(positionMap(idx_s(i),1),positionMap(idx_s(i),2)) = ElVec{idx_s(i)}.P;
    i = i +1;
end
end

