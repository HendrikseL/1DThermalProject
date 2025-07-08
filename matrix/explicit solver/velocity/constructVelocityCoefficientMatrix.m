function [Av,bv] = constructVelocityCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryPgrad,slurryRho)
%constructs a coefficient matrix to be used to calculate the velocity
%fields at the cell centers

%initialize sparse matrix
Av = zeros(length(slurryVel),length(slurryVel));
bv = zeros(1,length(slurryVel));

%% Coeficient Array (AP)

%counter k as an inlet boundary node counter
k = 1;

%slurry inlet boundary nodes (separate to allow for changing boundary)
for i = 1:1:globalInputs.program.radialNodes
    Av(k,k) = -1;
    bv(k) = slurryVel(k);

    k = k+1;  
end

%construct coefficient matrix for each internal node
i = k;
while ~isempty(ElVec{slurryPositionMap(i,3)})
    j =i;
    neighbours = findNeighboursPosition(ElVec{slurryPositionMap(i,3)}.neighbours, slurryPositionMap, 3);


    Ap = -(2*ElVec{slurryPositionMap(i,3)}.mu/ElVec{slurryPositionMap(i,3)}.x^2) -((slurryRho(i,1)-slurryRho(neighbours(1),1))/ElVec{slurryPositionMap(i,3)}.x)*slurryVel(i) ...
        -((slurryRho(i,1)*slurryVel(i))/ElVec{slurryPositionMap(i,3)}.x) -((slurryRho(i,1) - slurryRho(i,2))/globalInputs.program.timeStep);
    Aw = (ElVec{slurryPositionMap(i,3)}.mu/ElVec{slurryPositionMap(i,3)}.x^2) + (slurryRho(i,1)*slurryVel(i))/ElVec{slurryPositionMap(i,3)}.x;
    Ae = (ElVec{slurryPositionMap(i,3)}.mu/ElVec{slurryPositionMap(i,3)}.x^2);

    Av(i,j) = Ap;
    bv(i) = -slurryPgrad(i);


    %western neighbour
    if ~(neighbours(1) == 0)
        Av(i,neighbours(1)) = Aw;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        Av(i,neighbours(3)) = Ae;
    end

    i = i + 1;
end


%slurry outlet boundary nodes
while i <= length(Av(:,1))
    Av(i,i) = 1;
    bv(i) = 0;

    nMax = 1;
    neighbour = findNeighboursPosition([slurryPositionMap(i,1),slurryPositionMap(i,2)-1], slurryPositionMap, nMax);

    Av(i,neighbour) = -1; 
    i = i +1;
end

end





