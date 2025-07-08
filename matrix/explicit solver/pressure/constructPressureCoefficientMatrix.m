function [AP, bP] = constructPressureCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryP,slurryRho)
%constructs a coefficient matrix to be used to calculate the pressure at
%cell faces. Velocity input vector must be for cell center vleocities.

%initialize sparse matrix
AP = zeros(length(slurryP),length(slurryP));
bP = zeros(1,length(slurryP));

%% Coeficient Array (AP)

%counter k as an inlet boundary node counter
k = 1;

%zero gradient pressure boundary at inlet
for i = 1:1:globalInputs.program.radialNodes
    AP(k,k) = 1;
    bP(k) = 0;

    nMax = 1;
    neighbour = findNeighboursPosition([slurryPositionMap(i,1),slurryPositionMap(i,2)+1], slurryPositionMap, nMax);

    AP(i,neighbour) = -1; 
    k = k +1;
end

%construct coefficient matrix for each internal node
i = k;
while ~isempty(ElVec{slurryPositionMap(i,3)})
    j =i;
    neighbours = findNeighboursPosition(ElVec{slurryPositionMap(i,3)}.neighbours, slurryPositionMap, 3);


    Ap = -(2/ElVec{slurryPositionMap(i,3)}.x^2); 
    Aw = (1/ElVec{slurryPositionMap(i,3)}.x^2);
    Ae = (1/ElVec{slurryPositionMap(i,3)}.x^2);

    AP(i,j) = Ap;

    %gross math - comes from a 1D simplification of the compressible
    %pressure poisson equation
    dRhodt = ((slurryRho(i,1) - slurryRho(i,2))/globalInputs.program.timeStep);
    dRhodt_west = ((slurryRho(neighbours(1),1) - slurryRho(neighbours(1),2))/globalInputs.program.timeStep);
    dRhodt_east = ((slurryRho(neighbours(3),1) - slurryRho(neighbours(3),2))/globalInputs.program.timeStep);
    dVeldt = ((slurryVel(i,1) - slurryVel(i,2))/globalInputs.program.timeStep);
    dVeldt_west = ((slurryVel(neighbours(1),1) - slurryVel(neighbours(1),2))/globalInputs.program.timeStep);

    bP(i) = (-(slurryRho(i)+1)*slurryVel(i)*(dRhodt-dRhodt_west)/ElVec{slurryPositionMap(i,3)}.x) + (slurryRho(i)*(slurryVel(neighbours(1),1)-2*slurryVel(i,1) + slurryVel(neighbours(3),1))/ElVec{slurryPositionMap(i,3)}.x^2) ...
            + (slurryVel(i,1)*(slurryVel(i,1)-slurryVel(neighbours(1),1))/ElVec{slurryPositionMap(i,3)}.x) + (slurryVel(i,1)^2*(slurryRho(neighbours(1),1)-2*slurryRho(i,1)+slurryRho(neighbours(3),1))/ElVec{slurryPositionMap(i,3)}.x^2) ...
            - (slurryRho(i)*(dVeldt - dVeldt_west)/ElVec{slurryPositionMap(i,3)}.x) + (ElVec{slurryPositionMap(i,3)}.mu*(dRhodt_east-2*dRhodt + dRhodt_west)/ElVec{slurryPositionMap(i,3)}.x^2);


    %western neighbour
    if ~(neighbours(1) == 0)
        AP(i,neighbours(1)) = Aw;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        AP(i,neighbours(3)) = Ae;
    end

    i = i + 1;
end


%slurry outlet boundary nodes
while i <= length(AP(:,1))
    AP(i,i) = -1;
    bP(i) = slurryP(i);
 
    i = i +1;
end

end

