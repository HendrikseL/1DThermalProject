function ElVec = calculateSlurryVelocity(globalInputs,ElVec,i,du,d2u)
%Calculates the axial velocity for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily


ElVec{i}.vel(1) = ElVec{i}.vel(1) + globalInputs.program.timeStep* ( (-1/ElVec{i}.rho)*ElVec{i}.Pgrad + (1/ElVec{i}.rho)*ElVec{i}.mu*d2u - ElVec{i}.vel(1)*du);

end

