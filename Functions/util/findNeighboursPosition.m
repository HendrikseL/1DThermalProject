function neighbours = findNeighboursPosition(neighboursIn,positionMap,nMax)
%find the neighbouring elements in the position map

for n = 1:1:nMax
    %eastern neighbour
    index = 0;
    k = 1;
    while k <= length(positionMap) && index == 0
        if neighboursIn(n,1) == positionMap(k,1) && neighboursIn(n,2) == positionMap(k,2)
                index = k;
        end
        k = k +1;
    end
 
    neighbours(n) = index;
end

end

