function T_new = explicitSolver(A,Q,b,Tvec,ElVec,globalInputs)
    %explicit solver for the temperature using the coefficient matrix
    T_new = zeros(length(Tvec),1);
    
    %inlet boundary condition
    for i = 1:1:2+globalInputs.program.radialNodes
        T_new(i) = Tvec(i);
    end

    %solve nodes
    for i = 2+globalInputs.program.radialNodes+1:1:length(Tvec)-(2+globalInputs.program.radialNodes)
        T_new(i) = Tvec(i) + (globalInputs.program.timeStep/(ElVec{i}.rho*ElVec{i}.c*ElVec{i}.vol))*-(A(i,:)*Tvec' + b(i) - Q(i));
    end

    %outlet boundary
    for i = length(Tvec):-1:length(Tvec)-(1+globalInputs.program.radialNodes)
        T_new(i) = -(A(i,:)*T_new+ b(i) - Q(i));
    end

end

