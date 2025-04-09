function Q = constructHeatFlowInput(ElVec,Tdist,globalInputs)
Q = zeros(1,length(ElVec));

%offset the index to the first non empty index in elvec
i = 0;
idxFound = false;
while ~idxFound
    i = i + 1;
    if ~isempty(ElVec{i})
        idxFound = true;
        offset = i;
    end
end

%find where the outerpipe nodes begin
startIndex = 0;
while i < length(ElVec) && startIndex == 0
    if strcmp(ElVec{i}.type, "outerPipe")
        startIndex = i;
    end
    i = i +1;
end

%heat loss to ambient atmosphere
for i = startIndex:1:(startIndex+globalInputs.program.N*globalInputs.program.M-1)
    Q(i) = -ElVec{i}.II1*(globalInputs.temperature.Ta+273.15);
end

end

