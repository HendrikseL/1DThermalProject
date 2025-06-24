function idx_s = findSlurryNodesIndex(ElVec,globalInputs)
%Returns an array of the indices that contain a slurry node inside ElVec

%prealloc idx_s for speed
idx_s = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes,1);

i = 1;
counter = 1;
while i < length(ElVec)
    if ~isempty(ElVec{i}) && strcmp(ElVec{i}.type,"slurry")
        idx_s(counter) = i;
        counter = counter +1;
    end

    i = i +1;
end

end

