function [Tdist,settings] = outFileRead(fileName)
%this function reads in an output file  and logs the settings

    fid = fopen(fileName,"r");

    %skip past header to settings fields
    tline = fgetl(fid);
    tline = fgetl(fid);
    tline = fgetl(fid);
    tline = fgetl(fid);

    %fill in settings
    for i = 1:1:5
        field = split(tline,",");
        settings(i) = str2double(field{2}); 
        tline = fgetl(fid);
    end

    N = settings(1); 
    M = settings(2);
    r = settings(3);

    Tdist = zeros(5+r, N*M+4);
    time = 0; %counter for time step
    %read the rest of the fields
    tline = fgetl(fid);
    while ~isnumeric(tline)
        if contains(tline,"Time")
            time = time + 1;

            %Read in the temperature matrix in the file for a time step
            for i = 1:1:5+r
                    tline = fgetl(fid);
                    temps = split(tline,",");
                    for j = 1:1:N*M+4
                        Tdist(i,j,time) = str2double(temps{j});
                    end
            end
        end
        tline = fgetl(fid);
    end

    fclose(fid);
end