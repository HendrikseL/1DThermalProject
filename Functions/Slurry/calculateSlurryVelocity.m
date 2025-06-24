function ElVec = calculateSlurryVelocity(globalInputs,ElVec,idx_s,du,d2u)
%Calculates the axial velocity for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily

%calculate new velocity field
vel_new = zeros(length(idx_s),1);

i= 1;
while i <= length(idx_s)
    vel_new(i) = ElVec{idx_s(i)}.vel(1) + globalInputs.program.timeStep* ( (-1/ElVec{idx_s(i)}.rho)*ElVec{idx_s(i)}.Pgrad + (1/ElVec{idx_s(i)}.rho)*ElVec{idx_s(i)}.mu*d2u(i) - ElVec{idx_s(i)}.vel(1)*du(i));
    i = i + 1;
end

%update the old velocity field with the new values
i = 1;
while i <= length(idx_s)
    ElVec{idx_s(i)}.vel(1) = vel_new(i);
    i = i +1;
end

end