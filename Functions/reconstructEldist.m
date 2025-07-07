function ElDist = reconstructEldist(ElVec,ElDist,positionMap)
%update Elemnts in the main ElDist array
i = 1;
%offset to start of filled ElVec
while isempty(ElVec{i})
    i = i +1;
end

while i <= length(ElVec) && ~isempty(ElVec{i})
    ElDist(positionMap(i,1),positionMap(i,2)) = ElVec(i);
    i = i +1;
end

end


