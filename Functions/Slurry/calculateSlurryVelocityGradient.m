function [du, d2u] = calculateSlurryVelocityGradient(TPP,globalInputs,positionMap,ElVec,Tvec,idx_s)

%prealloc for speed
du = zeros(length(idx_s),1);
d2u = zeros(length(idx_s),1);

i = 1;
while i <= length(idx_s)

    %Calculates the axial velocity gradients for the slurry. i is current node.
    neighbours = findNeighboursPosition(ElVec{idx_s(i)}.neighbours, positionMap, 4);
    
    %check for eastern and western neighbours
    if isempty(ElVec{neighbours(1)})
        [vel_west,~] = initializeSlurryVelocity(globalInputs,ElVec{idx_s(i)}.pos,ElVec{idx_s(i)}.rho); 
        vel_west = vel_west(1);

        rho_west = calculateSlurryDensity(TPP,globalInputs,Tvec(neighbours(1),ElVec{neighbours(1)}.alpha));
    else
        vel_west = ElVec{neighbours(1)}.vel(1);
        rho_west = ElVec{neighbours(1)}.rho;
    end
    
    %check for eastern and western neighbours
    if isempty(ElVec{neighbours(3)})
        vel_east = ElVec{idx_s(i)}.vel(1);
    else
        vel_east = ElVec{neighbours(3)}.vel(1);
    end
    
    
    %first derivative
    du(i) = (ElVec{idx_s(i)}.rho*ElVec{idx_s(i)}.vel(1) - rho_west*vel_west)/ElVec{idx_s(i)}.x; %western neighbour is used
    
    %second derivative
    d2u(i) = (vel_east - 2*ElVec{idx_s(i)}.vel(1) + vel_west)/(ElVec{idx_s(i)}.x)^2;

    i = i +1;

end

end

