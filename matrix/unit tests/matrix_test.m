%tests for the matrix solvers. will initialize an isothermal matrix and
%esnure that lhs = rhs for all equations

main

for i =1:1:length(theta(:,1))
    error(i) = 353.15*(sum(theta(i,:))) - Q(i) + b(i);
end