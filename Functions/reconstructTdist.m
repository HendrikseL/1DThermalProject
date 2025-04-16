function Tdist_new = reconstructTdist(T_new,T_flange,positionMap,Tdist)
%reconstructs the  temperature disribution from  the newly calculate
%temperatures

Tdist_new = Tdist;

%update flanges
Tdist_new(1:3,1) = T_flange(1,1);
Tdist_new(1:3,2) = T_flange(2,1);
Tdist_new(1:3,end-1) = T_flange(3,1);
Tdist_new(1:3,end) = T_flange(4,1);

%update the rest
for i = 1:1:length(T_new)
    Tdist_new(positionMap(i,1),positionMap(i,2)) = T_new(i);
end

%copy the padding conditions for visualization
%first row
for i = 4:1:length(Tdist_new(:,1))
    Tdist_new(i,1) = Tdist_new(i,2);
end
%last row
for i = 4:1:length(Tdist_new(:,1))
    Tdist_new(i,end) = Tdist_new(i,end-1);
end

end

