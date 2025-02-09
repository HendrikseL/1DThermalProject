function T = constructSlurryTemperatureMatrix(globalInputs, slurry)
    %Rows = radial nodes. Cols = 2 for input, N slurry nodes, 2 for output
    T = zeros(globalInputs.program.radialNodes,2+globalInputs.program.N+2); 
    
    for i = 1:1:globalInputs.program.radialNodes %radial slurry nodes
        T(i,1:2) = globalInputs.slurry.Ts_in;


        for j = 1:1:globalInputs.program.N %number of axial slurry nodes
            
        end
    end
end