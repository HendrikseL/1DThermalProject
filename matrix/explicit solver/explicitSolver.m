function [T_new, ElVec] = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap,TPP)
%solves the governing equations explicitly. This has been done to avoid the need for two coefficient matrices with complex boundary handling. 
%The framework should support implicit solutions, but currently that is not implemented
%This solver contains functions that explicitly solve each of the three governing equations

%pull out properties from objects, this is done to create solution vectors
%of the primative variables for the solvers.
[slurryVel, slurryP, slurryPgrad, slurryPositionMap, slurryTvec, slurryRho] = findSlurryNodeProperties(ElVec,globalInputs,positionMap,Tvec);

p = 1;
while p <= globalInputs.program.pIterations

    %calculates velocity at n+1/2, at the faces
    slurryVel(:,1) = calculateSlurryVelocity(globalInputs,slurryPositionMap,ElVec,slurryVel(:,1),slurryPgrad,slurryRho);

    %rhie and chow
    % %calculate pressure gradient at n+1/2
    [AP , bP] = constructPressureCoefficientMatrix(globalInputs,slurryPositionMap,ElVec,slurryVel,slurryP,slurryRho);
    % Pdist = reconstructPdist(globalInputs,ElVec,positionMap);
    % %update density for new pressure field
    % ElVec = updateSlurryDensities(globalInputs,TPP,ElVec,Tvec,idx_s);

    p = p +1;
end
%reconstruct element field
ElVec = updateElementVector(ElVec, slurryVel, slurryRho, slurryPgrad, slurryP,slurryPositionMap);

%%Energy Equation Solver
T_new = solveEnergyEquation(A,Q,b,Tvec,ElVec,globalInputs);

end

