function [theta,Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs)
%creates a coefficient matrix with transient terms not included. Meant for use
%with the explicit solver.

%initialize sparse matrix
len = (length(ElDist(1,:))-4)*(length(ElDist(:,1))-1) +2*(globalInputs.program.radialNodes+2); %array length incudes elements and boundary nodes
theta = zeros(len,len);

%%Create position map. maps temperature and elements into a vector for use
%%as the 'x' term in the linear equation

%initialize Tvec and ElVec
Tvec = zeros(1,len);
ElVec = cell(1,len);

[positionMap,ElVec,Tvec] = createPositionMap(globalInputs,ElDist,Tdist,ElVec,Tvec);

%b vector for linearr equation
b = zeros(1,len);

%% Coeficient Array (A)

%reusing counter k as a inlet boundary node counter
k = 1;

%slurry inlet boundary nodes (separate to allow for changing boundary)
for i = 1:1:globalInputs.program.radialNodes
    theta(k,k) = -1;
    b(k) = (globalInputs.temperature.in.Ts+273.15);

    k = k+1;  
end

%inner pipe inlet boundary condition
theta(k,k) = -1;
b(k) = (globalInputs.temperature.in.Tip+273.15);

k = k+1; 
    
%screw inlet boundary condition
theta(k,k) = -1;
b(k) = (globalInputs.temperature.in.Tsc+273.15);

k = k+1; 

%construct coefficient matrix for each internal node
i = k;
while ~isempty(ElVec{i})
    j =i;
 
    theta(i,j) = ElVec{i}.Ap;
    b(i) = 0;
    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

    %Go through and assign coefficients to proper placement. Where
    %neighbours is empty, a neighbour does not exist.

    %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.Aw;
    else
        b(i) = b(i) +ElVec{i}.Aw * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)-1);
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta(i,neighbours(2)) = ElVec{i}.An;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.Ae;
    else
        b(i) = b(i) +ElVec{i}.Ae * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)+1);
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta(i,neighbours(4)) = ElVec{i}.As;
    end

    i = i + 1;

end


%slurry outlet boundary nodes
k = i;
while k < length(ElVec) + 1
    theta(k,k) = 1;
    b(k) = 0;

    nMax = 1;
    neighbour = findNeighboursPosition([positionMap(k,1),length(Tdist(1,:))-globalInputs.program.outputPadding], positionMap, nMax);

    theta(k,neighbour) = -1;
    k = k+1; 
end

end

