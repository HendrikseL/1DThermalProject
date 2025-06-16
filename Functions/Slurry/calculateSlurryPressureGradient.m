function ElVec = calculateSlurryPressureGradient(globalInputs,ElVec,i,du,d2u)
%Calculates the axial pressure gradient for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily

ElVec{i}.Pgrad = (ElVec{i}.rho * ElVec{i}.vel(1))/globalInputs.program.timeStep - ElVec{i}.rho * ElVec{i}.vel(1) * du + ElVec{i}.mu *d2u;

end

