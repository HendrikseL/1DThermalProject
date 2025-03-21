function [theta,Tvec] = constructCoefMatrix_debug(ElDist,Tdist,globalInputs)
%This function is a copy of constructCoefMatrix. It is meant to be
%identical except instead of placing the coeficients for the matrix, it
%places a string coressponding to their  type (A0, A1, etc) and their
%position in the Eldist matrix.

%initialize sparse matrix
theta = cell((length(ElDist(1,:))-4)*(length(ElDist(:,1))-1),(length(ElDist(1,:))-4)*(length(ElDist(:,1))-1));

%fill the main diagonal 
N = globalInputs.program.N;
M = globalInputs.program.M;
r = globalInputs.program.radialNodes;
offset = globalInputs.program.offset;

%%Temperature vector
k = 1; %counter

%initialize Tvec and ElVec
% Tvec = zeros(1,(length(ElDist(1,:))-4)*(length(ElDist(:,1))-1));
Tvec = cell(1,(length(ElDist(1,:))-4)*(length(ElDist(:,1))-1));
ElVec = cell(1,(length(ElDist(1,:))-4)*(length(ElDist(:,1))-1));

%slurry
for i = globalInputs.program.radialNodes+offset:-1:1+offset
    for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        % Tvec(k) = Tdist(i,j);
        Tvec{k} = strcat(ElDist{i,j}.type," ",num2str(i),num2str(j));
        ElVec{k} = ElDist{i,j};
        positionMap(k,:) = ElDist{i,j}.pos;

        k = k+1;
    end
end

%inner pipe
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec{k} = strcat(ElDist{4,j}.type," ",num2str(i),num2str(j));
        ElVec{k} = ElDist{4,j};
        positionMap(k,:) = ElDist{4,j}.pos;

        k = k+1;
end

%coolant
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec{k} = strcat(ElDist{3,j}.type," ",num2str(i),num2str(j));
        ElVec{k} = ElDist{3,j};
        positionMap(k,:) = ElDist{3,j}.pos;

        k = k+1;
end

%screw
for j =  globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec{k} = strcat(ElDist{globalInputs.program.radialNodes+offset+1,j}.type," ",num2str(i),num2str(j));
        ElVec{k} = ElDist{globalInputs.program.radialNodes+offset+1,j};
        positionMap(k,:) = ElDist{globalInputs.program.radialNodes+offset+1,j}.pos;

        k = k+1;
end

%outer pipe
for j = globalInputs.program.inputPadding+1:1:(N*M)+globalInputs.program.inputPadding
        Tvec{k} = strcat(ElDist{2,j}.type," ",num2str(i),num2str(j));
        ElVec{k} = ElDist{2,j};
        positionMap(k,:) = ElDist{2,j}.pos;

        k = k+1;
end

%% Coeficient Array

%slurry nodes
for i = 1:1:N*M*r
    j =i;

    theta{i,j} = strcat("A1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2))); 
    %theta(i,j) = ElVic{i}.A1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}, positionMap, nMax);

    %Go through and assign coefficients to proper placement. Where
    %neighbours is empty, a neighbour does not exist.
    %This is not in a loop because each neighbour receives different
    %coefficients

    %western neighbour
    if ~(neighbours(1) == 0)
        theta{i,neighbours(1)} = strcat("A0 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta{i,neighbours(2)} = strcat("B1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta{i,neighbours(3)} = strcat("A2 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta{i,neighbours(4)} = strcat("C1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

end

%inner pipe
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta{i,j} = strcat("J1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2))); 
    %theta(i,j) = ElVic{i}.J1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta{i,neighbours(1)} = strcat("J0 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta{i,neighbours(2)} = strcat("L1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta{i,neighbours(3)} = strcat("J2 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta{i,neighbours(4)} = strcat("K1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end
end

%coolant 
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta{i,j} = strcat("D1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2))); 
    %theta(i,j) = ElVic{i}.A1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}, positionMap, nMax);

    %western neighbour
    if ~(neighbours(1) == 0)
        theta{i,neighbours(1)} = strcat("D0 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta{i,neighbours(2)} = strcat("EE1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta{i,neighbours(3)} = strcat("D2 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta{i,neighbours(4)} = strcat("E1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

end

%screw
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta{i,j} = strcat("F1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2))); 
    %theta(i,j) = ElVic{i}.A1;

    nMax = 3;
    neighbours = findNeighboursPosition(ElVec{i}, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta{i,neighbours(1)} = strcat("F0 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        theta{i,neighbours(2)} = strcat("G1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta{i,neighbours(3)} = strcat("F2 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

end

%outer pipe
startIndex = i;
for i = startIndex+1:1:startIndex+N*M
    j =i;

    theta{i,j} = strcat("H1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2))); 
    %theta(i,j) = ElVic{i}.A1;

    nMax = 4;
    neighbours = findNeighboursPosition(ElVec{i}, positionMap, nMax);

        %western neighbour
    if ~(neighbours(1) == 0)
        theta{i,neighbours(1)} = strcat("H0 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %northern neighbour
    if ~(neighbours(2) == 0)
        %used in the Q source matrix will never go in theta
        theta{i,neighbours(2)} = strcat("II1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %eastern neighbour
    if ~(neighbours(3) == 0)
        theta{i,neighbours(3)} = strcat("H2 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

    %southern neighbour
    if ~(neighbours(4) == 0)
        theta{i,neighbours(4)} = strcat("I1 ", num2str(ElVec{i}.pos(1)), " ",num2str(ElVec{i}.pos(2)));
    else
        %do nothing
    end

end

end

