function [slurryVel, slurryP, slurryPgrad, slurryPositionMap, slurryTvec, slurryRho] = findSlurryNodeProperties(ElVec,globalInputs,positionMap,Tvec)
%Goes through ElVec and creates the necessary vectors and position maps to
%solve the slurry segment of the whole domain for the pressure
%predictor-corrector loop.

%slurryPositionMap stores the nodes position (to find neighbours) and the
%index psoition within positionMap to make updating the objects at the end
%easier

%the remaining vectors are the property fields aligned with the new position
%map

%prealloc for speed
slurryPositionMap = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,3);
slurryTvec = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,1);
slurryVel = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,2);
slurryP = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,1);
slurryPgrad = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,1);
slurryRho = zeros(globalInputs.program.M*globalInputs.program.N*globalInputs.program.radialNodes + 2*globalInputs.program.radialNodes,3);
i = 1;
counter = 1;

%go through inlet nodes (first set are slurry are slurrry)
%pressure cannot be handled here, its boundary is similar to the outlet
%boundaries.
while isempty(ElVec{i})
    if i <= globalInputs.program.radialNodes
        slurryPositionMap(counter,:) = [positionMap(i,1),positionMap(i,2),i];
        slurryVel(counter,:) = [globalInputs.slurry.initialV(positionMap(i,1)-4),globalInputs.slurry.initialV(positionMap(i,1)-4)]; 

        slurryTvec(counter) = Tvec(i);
        slurryPgrad(counter) = globalInputs.slurry.Pgrad;
        slurryRho(counter,:) = [globalInputs.slurry.initialRho,globalInputs.slurry.initialRho,globalInputs.slurry.initialRho];
        counter = counter + 1;
    end
    i = i+ 1;
end


while ~isempty(ElVec{i})
    if ~isempty(ElVec{i}) && strcmp(ElVec{i}.type,"slurry")
        slurryPositionMap(counter,:) = [positionMap(i,1),positionMap(i,2),i];
        slurryVel(counter,:) = [ElVec{i}.vel(1),ElVec{i}.vel(1)];
        slurryP(counter) = ElVec{i}.P;
        slurryTvec(counter) = Tvec(i);
        slurryPgrad(counter) = ElVec{i}.Pgrad;
        slurryRho(counter,:) = [ElVec{i}.rho,ElVec{i}.rho_old(1),ElVec{i}.rho_old(2)];
        counter = counter +1;
    end

    i = i +1;
end

%go through outlet boundaries

while i <= length(ElVec)
    if positionMap(i,1) > 4 && positionMap(i,1) < globalInputs.program.radialNodes+5
        slurryPositionMap(counter,:) = [positionMap(i,1),positionMap(i,2),i];

        %find position of neighbour to the west
        neighbour = findNeighboursPosition([positionMap(i,1),positionMap(i,2)-1],slurryPositionMap,1);

        slurryVel(counter,:) = slurryVel(neighbour,:); 
        slurryP(counter) = globalInputs.slurry.P;
        slurryPgrad(counter) = slurryPgrad(neighbour); %not used
        slurryRho(counter,:) = slurryRho(neighbour,:); %not used
        slurryTvec(counter) = Tvec(i);
        counter = counter + 1;
    end
    i = i +1;
end

%fill in the pressure inlet now that the main region is resolved
i = 1;
while i <= globalInputs.program.radialNodes
    neighbour = findNeighboursPosition([0,0;0,0;positionMap(i,1),positionMap(i,2)+1],slurryPositionMap,3);
    slurryP(i) = slurryP(neighbour(3));

    i = i +1;
end

end

