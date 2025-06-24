function T_new = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap)
%solves the governing equations explicitly. This has been done to avoid the need for two coefficient matrices with complex boundary handling. 
%The framework should support implicit solutions, but currently that is not implemented
%This solver contains functions that explicitly solve each of the three governing equations

%locate slurry indices
idx_s = findSlurryNodesIndex(ElVec,globalInputs);

p = 1;
while p <= globalInputs.program.pIterations
    [du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,idx_s);
    %calculates velocity at n+1/2
    ElVec = calculateSlurryVelocity(globalInputs,ElVec,idx_s,du,d2u);

    %calculate pressure gradient at n+1/2
    ElVec = calculateSlurryPressureGradient(globalInputs,positionMap,ElVec,idx_s,d2u);

    p = p +1;
end
%correct the velocity field to respect continuity (after full
%loop of predictor corrector)
[du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,idx_s);
ElVec = calculateSlurryVelocity(globalInputs,ElVec,idx_s,du,d2u);


%%Energy Equation Solver
T_new = solveEnergyEquation(A,Q,b,Tvec,ElVec,globalInputs);

end

