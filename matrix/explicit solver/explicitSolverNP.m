function [T_new, ElVec, slurryPositionMap, slurryP,slurryVel] = explicitSolverNP(A,Q,b,Tvec,ElVec,globalInputs,positionMap,TPP)
%THIS VERSION DOES NOT INCLUDE A PRESSURE SOLUTION, PRESSURE IS SET TO 0
%solves the governing equations explicitly. This has been done to avoid the need for two coefficient matrices with complex boundary handling. 
%The framework should support implicit solutions, but currently that is not implemented
%This solver contains functions that explicitly solve each of the three governing equations

%pull out properties from objects, this is done to create solution vectors
%of the primative variables for the solvers.
[slurryVel, slurryP, ~, slurryPositionMap, ~, slurryRho] = findSlurryNodeProperties(ElVec,globalInputs,positionMap,Tvec);

%%Velocity Solver (continuity based)
i = 1;
while i <= length(slurryPositionMap)
    if ~isempty(ElVec{slurryPositionMap(i,3)})
        ElVec{slurryPositionMap(i,3)}.vel(1) = (ElVec{slurryPositionMap(i,3)}.vel(1) * slurryRho(i,3)) / slurryRho(i,2);
        ElVec{slurryPositionMap(i,3)}.vel(2) = (ElVec{slurryPositionMap(i,3)}.vel(2) * slurryRho(i,3)) / slurryRho(i,2);
    end
    i = i +1;
end

%%Energy Equation Solver
T_new = solveEnergyEquation(A,Q,b,Tvec,ElVec,globalInputs);

end

