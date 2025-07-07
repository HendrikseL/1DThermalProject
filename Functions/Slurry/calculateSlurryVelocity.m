function ElVec = calculateSlurryVelocity(TPP,globalInputs,positionMap,ElVec,Tvec,idx_s)
%Calculates the axial velocity for the slurry object at position i. Returns the
%whole vector of object to avoid copying objects unecessarily

[du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,idx_s);
drho = calculateSlurryDensityGradient(TPP,globalInputs,positionMap,ElVec,Tvec,idx_s);

%calculate new velocity field
vel_new = zeros(length(idx_s),1);

i= 1;
while i <= length(idx_s)
    vel_new(i) = ElVec{idx_s(i)}.vel(1) + (globalInputs.program.timeStep/ElVec{idx_s(i)}.rho)* (-ElVec{idx_s(i)}.Pgrad + ElVec{idx_s(i)}.mu*d2u(i) - ElVec{idx_s(i)}.rho*ElVec{idx_s(i)}.vel(1)*du(i) ...
        -ElVec{idx_s(i)}.vel(1)^2*drho(i) - (ElVec{idx_s(i)}.rho-ElVec{idx_s(i)}.rho_old)/globalInputs.program.timeStep) ;
    i = i + 1;
end

%update the old velocity field with the new values
i = 1;
while i <= length(idx_s)
    ElVec{idx_s(i)}.vel(1) = vel_new(i);
    i = i +1;
end

end