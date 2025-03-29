function Qnet = calculateNetHeatFlow(ElDist,Tdist, globalInputs)
%calculates Q net for a given temperature distribution
Qnet = zeros(1,globalInputs.program.M);


k = 3; %running total position

for j = 1:1:globalInputs.program.M
    for i = 1:1:globalInputs.program.N
        Qnet(j) = Qnet(j) + (Tdist(4,k)-Tdist(3,k))/(ElDist{3,k}.E1);
        Qnet(j) = Qnet(j) + (Tdist(2,k)-Tdist(3,k))/(ElDist{2,k}.I1); 

        k = k+ 1;
    end
end
end

