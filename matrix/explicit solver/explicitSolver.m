function T_new = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap)
    %explicit solver for the temperature using the coefficient matrix
    T_new = zeros(length(Tvec),1);
    
    k = 1;
    %inlet boundary condition
    for i = 1:1:2+globalInputs.program.radialNodes
        T_new(i) = Tvec(i);
        k = k+1;
    end

    %solve nodes
    i = k;
    while ~isempty(ElVec{i})

        %update velocity and pressure
        if strcmp(ElVec{i}.type,"slurry")
            %fluid is treated incompressible. Density is updated by the
            %temperature and state of the slurry
            %find neighbours for ElVec
            [du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,i);

            %make sure that for velocity calculations only the old velocity
            %is used not a new one!!!
            
            %guess slurry velocity at n+1 for velocity using n pressure
            %field
            ElVec = calculateSlurryVelocity(globalInputs,ElVec,i,du,d2u);

            %calculate pressure gradient at n+1
            ElVec = calculateSlurryPressureGradient(globalInputs,ElVec,i,du,d2u);

            %correct the velocity field to respect continuity
            ElVec = calculateSlurryVelocity(globalInputs,ElVec,i,du,d2u);
        end

        dT = (globalInputs.program.timeStep/(ElVec{i}.rho*ElVec{i}.c*ElVec{i}.vol))*-(A(i,:)*Tvec' + b(i) - Q(i));
        T_new(i) = Tvec(i) + dT;

        i = i +1;
    end

    k = i;
    %outlet boundary
    while k < length(ElVec) + 1
        T_new(k) = -(A(k,:)*T_new+ b(k) - Q(k));
        k = k +1;
    end

end

