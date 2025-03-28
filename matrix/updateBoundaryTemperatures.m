function Tdist_new = updateBoundaryTemperatures(Tdist,ElDist,TPP,globalInputs,cde)
%updates the temperature boundaries using eqs 31-33
%broken into two sections, one for inlet conditions and one for outlet.
%This function does not update the in/out values, only the temperatures in
%matrix M1.

Tdist_new = Tdist;
%%Inlet
for i = 2:1:length(ElDist(:,1))
    switch ElDist{i,3}.type

        case "slurry"
            Tdist_new(i,3) = getSlurryBoundary(Tdist,ElDist{i,3},TPP,globalInputs,"in");
        case "innerPipe"
            Tdist_new(i,3) = getInnerPipeBoundary(Tdist,TPP,globalInputs,"in",cde);
        case "screw"
            Tdist_new(i,3) = getScrewBoundary(TPP,globalInputs,"in");

    end
end

%%Outlet
for i = 2:1:length(ElDist(:,1))
    switch ElDist{i,(2+globalInputs.program.N*globalInputs.program.M)}.type

        case "slurry"
            Tdist_new(i,(2+globalInputs.program.N*globalInputs.program.M)) = getSlurryBoundary(Tdist,ElDist{i,(2+globalInputs.program.N*globalInputs.program.M)},TPP,globalInputs,"out");
        case "innerPipe"
            Tdist_new(i,(2+globalInputs.program.N*globalInputs.program.M)) = getInnerPipeBoundary(Tdist,TPP,globalInputs,"out",cde);
        case "screw"
            Tdist_new(i,(2+globalInputs.program.N*globalInputs.program.M)) = getScrewBoundary(TPP,globalInputs,"out");

    end

end

end

