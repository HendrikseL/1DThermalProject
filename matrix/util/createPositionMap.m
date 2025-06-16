function [positionMap,ElVec,Tvec] = createPositionMap(globalInputs,ElDist,Tdist,ElVec,Tvec)
%Creates a position map for a given input object matrix (ElDist).
%positionMap relates the index position within Tvec and ElVec to original 2D position within ElDist and
%Tdist.

%shorthand variable
offset = globalInputs.program.offset;

k = 1;

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

[paddingFront, paddingBack] = findPadding(ElDist);

%creating the position map for non-boundary nodes
for i = 2:1:length(ElDist(:,1))
    for j =  paddingFront:1:paddingBack
        Tvec(k) = Tdist(i,j);
        ElVec{k} = ElDist{i,j};
        positionMap(k,:) = ElDist{i,j}.pos;

        k = k+1;
    end
end

%outlet boundaries
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

end

