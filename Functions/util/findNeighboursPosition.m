function neighbours = findNeighboursPosition(neighboursIn,positionMap,nMax)
%find the neighbouring elements in the position map

%neighbours in order: west, north, south, east
%n should be equal to the desired direction.
for n = 1:1:nMax
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

