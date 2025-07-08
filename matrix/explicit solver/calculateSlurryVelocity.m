function slurryVel = calculateSlurryVelocity(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryPgrad,slurryRho)
%Calculates the axial velocity field for the slurry, explicitly 

    %calculate new velocity field
    vel_new = zeros(length(slurryVel),1);
    
    %calculates a coefficient matrix for the slurry velocity
    [Av, bv] = constructVelocityCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryPgrad,slurryRho);
    
    i= 1;
    while i <= length(slurryVel)
        vel_new(i) = slurryVel(i) + (globalInputs.program.timeStep/slurryRho(i,1))*(Av(i,:)*slurryVel(:) + bv(i));
        i = i +1;
    end
    
    %update the old velocity field with the new values
    slurryVel(:) = vel_new(:); %updated with new velocity

end