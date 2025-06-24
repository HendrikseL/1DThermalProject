function T_new = solveEnergyEquation(A, Q, b, Tvec, ElVec, globalInputs)
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

