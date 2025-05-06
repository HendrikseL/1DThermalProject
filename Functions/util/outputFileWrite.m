function outputFileWrite(globalInputs, Tdist, writeType, timeStep)
%creates an output file and writes the temperature matrix to the file.
%   writeType --> 1: initializes the file and writes the settings
%                       2: writes to the existing file

switch writeType
    %Initialize the file
    case 1
        fullFilePath = strcat(pwd ,"/",globalInputs.program.outFile);
        fid = fopen(fullFilePath,"w");

        %header and date
        t = datetime('now','TimeZone','local','Format','d-MMM-y HH:mm:ss');
        fprintf(fid,"Thermal Resistance Network Output \nsimulation run: %s\n\n",t);

        %simulation settings
        fprintf(fid,"Nodes per Heat Exchanger (N), %i \nHeat Exchangers (M), %i \nRadial Nodes (r), %i\nWrite Interval, %i \nTime Step, %d\n\n"...
            ,globalInputs.program.N, globalInputs.program.M, globalInputs.program.radialNodes,globalInputs.program.writeInterval, globalInputs.program.timeStep);

        %write initial time step to file
        fprintf(fid, "Time = %d secs (%i)\n", globalInputs.program.timeStep*(timeStep), timeStep);

        for i = 1:1:length(Tdist(:,1))
            for j = 1:1:length(Tdist(1,:))
                fprintf(fid,"%f, ",Tdist(i,j));
            end
            fprintf(fid,"\n");
        end
        fprintf(fid,"\n\n");

        fclose(fid);

    case 2
        fullFilePath = strcat(pwd ,"/",globalInputs.program.outFile);
        fid = fopen(fullFilePath,"a");

        %write initial time step to file
        fprintf(fid, "Time = %d secs (%i)\n", globalInputs.program.timeStep*(timeStep), timeStep);

        for i = 1:1:length(Tdist(:,1))
            for j = 1:1:length(Tdist(1,:))
                fprintf(fid,"%f, ",Tdist(i,j));
            end
            fprintf(fid,"\n");
        end
        fprintf(fid,"\n\n");

        fclose(fid);

end

end

