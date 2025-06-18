function ElVec = calculateSlurryPressureGradient(globalInputs,ElVec,i,du,d2u)
%Calculates the axial pressure gradient for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily

ElVec{i}.Pgrad = -ElVec{i}.rho * (d2u) * ElVec{i}.x;

end

