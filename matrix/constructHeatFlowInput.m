function Q = constructHeatFlowInput(ElVec,Tdist,globalInputs)
Q = zeros(1,length(ElVec));

%find where the outerpipe nodes begin
i = 1;
startIndex = 0;
while i < length(ElVec) && startIndex == 0
    if strcmp(ElVec{i}.type, "outerPipe")
        startIndex = i;
    end
    i = i +1;
end

%heat loss to ambient atmosphere
for i = startIndex:1:length(ElVec)
    Q(i) = -ElVec{i}.II1*(globalInputs.temperature.Ta+273.15);
end

end

