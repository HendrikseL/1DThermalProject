%********************
%Post Processor
%creates pretty pictures from output files
%
%Author: Luke Hendrikse
%*********************
clear
clc
clf

%input here
fileName = "out.txt";

%get full fie path
fullPath = strcat(pwd,"/",fileName);
[Tdist, settings] = outFileRead(fullPath);

%make flood plot of a time step
temperatureFloodPlot(Tdist(:,:,1),settings,0,[0 100],1)
%update figure
for i = 2:1:length(Tdist(1,1,:))
    temperatureFloodPlot(Tdist(:,:,i),settings,i-1,[0 100],2)
    pause(0.01)
end