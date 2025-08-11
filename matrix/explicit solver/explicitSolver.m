function [T_new, ElVec, slurryPositionMap, slurryP,slurryVel] = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap,TPP)
%solves the governing equations explicitly. This has been done to avoid the need for two coefficient matrices with complex boundary handling. 
%The framework should support implicit solutions, but currently that is not implemented
%This solver contains functions that explicitly solve each of the three governing equations

%pull out properties from objects, this is done to create solution vectors
%of the primative variables for the solvers.
[slurryVel, slurryP, slurryPgrad, slurryPositionMap, slurryTvec, slurryRho] = findSlurryNodeProperties(ElVec,globalInputs,positionMap,Tvec);

%rhie and chow for past time step vleocity (at this point vel^(n-1) and
%vel^(n) are equal)
[Av, ~] = constructVelocityCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryPgrad,slurryRho);
slurryVel_face(:,2) = centerToFaceInterp(Av, ElVec, slurryPositionMap, slurryVel(:,2), slurryP, slurryPgrad);

p = 1;
while p <= globalInputs.program.pIterations

    %calculates velocity at n+1/2, at the faces
    slurryVel(:,1) = calculateSlurryVelocity(globalInputs,slurryPositionMap,ElVec,slurryVel(:,1),slurryPgrad,slurryRho);

    %rhie and chow for current time step
    slurryVel_face(:,1) = centerToFaceInterp(Av, ElVec, slurryPositionMap, slurryVel(:,1), slurryP, slurryPgrad);

    % %calculate pressure gradient at n+1/2
    [slurryP, slurryPgrad] = calculateSlurryPressure(globalInputs,slurryPositionMap,ElVec,slurryVel_face(:,1),slurryP,slurryRho);
    
    %update density for new pressure field
    slurryRho = updateSlurryDensities(globalInputs,TPP,slurryRho,slurryP,ElVec,slurryTvec,slurryPositionMap);

    p = p +1;
end
%reconstruct element field
ElVec = updateElementVector(ElVec, slurryVel, slurryRho, slurryPgrad, slurryP,slurryPositionMap);
Rhodist = reconstructPdist(globalInputs,slurryRho,slurryPositionMap);
%%Energy Equation Solver
T_new = solveEnergyEquation(A,Q,b,Tvec,ElVec,globalInputs);

end

