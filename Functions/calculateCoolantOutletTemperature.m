function Tc_out = calculateCoolantOutletTemperature(TPP,Tdist,globalInputs,Qnet)
%calculates the new outlet coolant temperatures to compare to previous
%iteration coolant temperatures
Tc_out = zeros(1,globalInputs.program.M);
k = 3;
for j = 1:1:globalInputs.program.M

        cp_avg = 0;
        for i = 1:1:globalInputs.program.N
            cp_avg = cp_avg + calculateCoolantHeatCap(TPP,globalInputs,Tdist(3,k+i-1));
        end
        cp_avg = cp_avg/globalInputs.program.N;

        Tc_out(j) = Tdist(3,k) + Qnet(j)/(globalInputs.coolant.m*cp_avg);

        k = k+ globalInputs.program.N;
end
end

