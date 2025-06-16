function [du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,i)
%Calculates the axial velocity gradients for the slurry. i is current node.
neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, 4);

%check for eastern and western neighbours
if isempty(ElVec{neighbours(1)})
    [vel_west,~] = initializeSlurryVelocity(globalInputs,ElVec{i}.pos,ElVec{i}.rho); 
    vel_west = vel_west(1);
else
    vel_west = ElVec{neighbours(1)}.vel(1);
end

%check for eastern and western neighbours
if isempty(ElVec{neighbours(3)})
    vel_east = ElVec{i}.vel(1);
else
    vel_east = ElVec{neighbours(3)}.vel(1);
end


%first derivative
du = (ElVec{i}.vel(1) - vel_west)/ElVec{i}.x; %western neighbour is used

%second derivative
d2u = (vel_east - 2*ElVec{i}.vel(1) + vel_west)/(ElVec{i}.x)^2;
end

