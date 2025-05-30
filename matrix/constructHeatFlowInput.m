function Q = constructHeatFlowInput(ElVec,Tdist,globalInputs,positionMap)
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
i = offset;
while i < length(ElVec) && i < (offset + globalInputs.program.N*globalInputs.program.M*(4+globalInputs.program.radialNodes))

    switch ElVec{i}.type

        case "slurry" 
            %find neighbour on position map
            neighbour = 0;
            j = 1;
            while neighbour == 0
                if positionMap(j,1) == ElVec{i}.neighbours(1,1) && positionMap(j,2) == ElVec{i}.neighbours(1,2)
                    neighbour = j;
                end
                j = j+1;
            end

            %check if neighbour node is an inlet
            if positionMap(neighbour,2) == 2
                neighbourVel = ElVec{i}.vel;
            else
                neighbourVel = ElVec{neighbour}.vel;
            end

            Q(i) = ElVec{i}.Q + ElVec{i}.ms(1)*(neighbourVel(1) - ElVec{i}.vel(1)) + ElVec{i}.ms(2)*(neighbourVel(2) - ElVec{i}.vel(2));
        case "outerPipe"
            Q(i) = -ElVec{i}.II1*(globalInputs.temperature.Ta+273.15);

    end


    i = i +1;
end


end

