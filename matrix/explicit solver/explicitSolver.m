function T_new = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs,positionMap)
    %explicit solver for the temperature using the coefficient matrix
    T_new = zeros(length(Tvec),1);
    
    %inlet boundary condition
    for i = 1:1:2+globalInputs.program.radialNodes
        T_new(i) = Tvec(i);
    end

    %solve nodes
    for i = 2+globalInputs.program.radialNodes+1:1:length(Tvec)-(2+globalInputs.program.radialNodes)

        %update velocity and pressure
        if strcmp(ElVec{i}.type,"slurry")
            %fluid is treated incompressible. Density is updated by the
            %temperature and state of the slurry
            %find neighbours for ElVec
            [du, d2u] = calculateSlurryVelocityGradient(globalInputs,positionMap,ElVec,i);

            %guess slurry velocity at n+1 for velocity using n pressure
            %field
            ElVec = calculateSlurryVelocity(globalInputs,ElVec,i,du,d2u);

            %calculate pressure gradient at n+1
            % ElVec = calculateSlurryPressureGradient(globalInputs,ElVec,i,du,d2u);

            %correct the velocity field to respect continuity
            ElVec = calculateSlurryVelocity(globalInputs,ElVec,i,du,d2u);
        end

        dT = (globalInputs.program.timeStep/(ElVec{i}.rho*ElVec{i}.c*ElVec{i}.vol))*-(A(i,:)*Tvec' + b(i) - Q(i));
        T_new(i) = Tvec(i) + dT;
    end

    %outlet boundary
    for i = length(Tvec):-1:length(Tvec)-(1+globalInputs.program.radialNodes)
        T_new(i) = -(A(i,:)*T_new+ b(i) - Q(i));
    end

end

