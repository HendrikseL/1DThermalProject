function [theta,Tvec,b,ElVec,positionMap] = constructCoefMatrix(ElDist,Tdist,globalInputs)
%This function is a copy of constructCoefMatrix. It is meant to be
%identical except instead of placing the coeficients for the matrix, it
%places a string coressponding to their  type (A0, A1, etc) and their
%position in the Eldist matrix.

%initialize sparse matrix
len = (length(ElDist(1,:))-4)*(length(ElDist(:,1))-1) +2*(globalInputs.program.radialNodes+2); %array length incudes elements and boundary nodes
theta = zeros(len,len);

%fill the main diagonal 
N = globalInputs.program.N;
M = globalInputs.program.M;
r = globalInputs.program.radialNodes;
offset = globalInputs.program.offset;

%%Temperature vector
k = 1; %row counter

%initialize Tvec and ElVec
Tvec = zeros(1,len);
ElVec = cell(1,len);

%slurry inlet boundary nodes
for i = globalInputs.program.radialNodes+offset:-1:1+offset
    Tvec(k) = Tdist(i,2);
    positionMap(k,:) = [i,2];
    k = k+1;  
end

%inner pipe inlet boundary condition
Tvec(k) = Tdist(4,2);
positionMap(k,:) = [4,2];
k = k+1;  

%screw inlet boundary condition
index = length(Tdist(:,1));
Tvec(k) = Tdist(index,2);
positionMap(k,:) = [index,2];
k = k+1; 


%slurry
for i = globalInputs.program.radialNodes+offset:-1:1+offset
    for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec(k) = Tdist(i,j);
        ElVec{k} = ElDist{i,j};
        positionMap(k,:) = ElDist{i,j}.pos;

        k = k+1;
    end
end

%inner pipe
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec(k) = Tdist(4,j);
        ElVec{k} = ElDist{4,j};
        positionMap(k,:) = ElDist{4,j}.pos;

        k = k+1;
end

%coolant
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec(k) = Tdist(3,j);
        ElVec{k} = ElDist{3,j};
        positionMap(k,:) = ElDist{3,j}.pos;

        k = k+1;
end

%screw
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec(k) = Tdist(globalInputs.program.radialNodes+offset+1,j);
        ElVec{k} = ElDist{globalInputs.program.radialNodes+offset+1,j};
        positionMap(k,:) = ElDist{globalInputs.program.radialNodes+offset+1,j}.pos;

        k = k+1;
end

%outer pipe
for j = globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec(k) = Tdist(2,j);
        ElVec{k} = ElDist{2,j};
        positionMap(k,:) = ElDist{2,j}.pos;

        k = k+1;
end

len = length(Tdist(1,:))-1;
%slurry outlet boundary nodes
for i = globalInputs.program.radialNodes+offset:-1:1+offset
    Tvec(k) = Tdist(i,len);
    positionMap(k,:) = [i,len];
    k = k+1;  
end

%inner pipe outlet boundary condition
Tvec(k) = Tdist(4,len);
positionMap(k,:) = [4,len];
k = k+1;  

%screw outlet boundary condition
index = length(Tdist(:,1));
Tvec(k) = Tdist(index,len);
positionMap(k,:) = [index,len];
k = k+1; 


b = zeros(1,k-1);

%% Coeficient Array

%reusing counter k as a inlet boundary node counter
k = 1;

%slurry inlet boundary nodes
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

%slurry nodes
for i = k:1:N*M*r+k-1
    j =i;
 
    theta(i,j) = ElVec{i}.A1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

    %Go through and assign coefficients to proper placement. Where
    %neighbours is empty, a neighbour does not exist.
    %This is not in a loop because each neighbour receives different
    %coefficients

    %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.A0;
    else
        b(i) = b(i) +ElVec{i}.A0 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)-1);
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta(i,neighbours(2)) = ElVec{i}.B1;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.A2;
    else
        b(i) = b(i) +ElVec{i}.A2 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)+1);
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta(i,neighbours(4)) = ElVec{i}.C1;
    end

end

%inner pipe
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta(i,j) = ElVec{i}.J1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.J0;
    else
        b(i) = b(i) + ElVec{i}.J0 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)-1);
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta(i,neighbours(2)) = ElVec{i}.L1;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.J2;
    else
        b(i) = b(i) + ElVec{i}.J2 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)+1);
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta(i,neighbours(4)) = ElVec{i}.K1;
    end
end

%coolant 
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;
 
    theta(i,j) = ElVec{i}.D1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

    %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.D0;
    else
        %western boundary (tc, in for coolant)
       b(i) = b(i) + ElVec{i}.D0 * Tdist(1,ElVec{i}.pos(2));
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta(i,neighbours(2)) = ElVec{i}.EE1;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.D2;
    else
        %eastern boundary (tc, out)
        b(i) = b(i) + ElVec{i}.D2 * Tdist(1,ElVec{i}.pos(2));
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta(i,neighbours(4)) = ElVec{i}.E1;
    end

end

%screw
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;
 
    theta(i,j) = ElVec{i}.F1;

    nMax = 3;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.F0;
    else
       %western boundary (tc, in for coolant)
       b(i) = b(i) + ElVec{i}.F0 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)-1);
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta(i,neighbours(2)) = ElVec{i}.G1;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.F2;
    else
       %eastern boundary (tc, in for coolant)
       b(i) = b(i) + ElVec{i}.F2 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)+1);
    end

end

%outer pipe
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta(i,j) = ElVec{i}.H1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}.neighbours, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta(i,neighbours(1)) = ElVec{i}.H0;
    else
       %western boundary (tc, in for coolant)
       b(i) = b(i) + ElVec{i}.H0 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)-1);
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        %used in the Q source matrix will never go in theta
        theta(i,neighbours(2)) = ElVec{i}.II1;
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta(i,neighbours(3)) = ElVec{i}.H2;
    else
       %eastern boundary (tc, in for coolant)
       b(i) = b(i) + ElVec{i}.H2 * Tdist(ElVec{i}.pos(1),ElVec{i}.pos(2)+1);
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta(i,neighbours(4)) = ElVec{i}.I1;
    end

end

%these are repeat codes. They have intetnionally been left seperate to
%allow for changing the boundary conditions of each type of node
%individually
k = i+1;
%slurry outlet boundary nodes
for i = 1:1:globalInputs.program.radialNodes
    theta(k,k) = 1;
    b(k) = 0;

    nMax = 1;
    neighbour = findNeighboursPosition([positionMap(k,1),len-1], positionMap, nMax);

    theta(k,neighbour) = -1;
    k = k+1; 
end

%inner pipe outlet boundary condition 
theta(k,k) = 1;
b(k) = 0;

nMax = 1;
neighbour = findNeighboursPosition([positionMap(k,1),len-1], positionMap, nMax);

theta(k,neighbour) = -1;
k = k+1;

    
%screw outlet boundary condition
theta(k,k) = 1;
b(k) = 0;

nMax = 1;
neighbour = findNeighboursPosition([positionMap(k,1),len-1], positionMap, nMax);

theta(k,neighbour) = -1;


end

