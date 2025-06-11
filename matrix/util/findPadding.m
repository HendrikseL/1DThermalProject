function [paddingFront, paddingBack] = findPadding(ElDist)
%Finds the padding of an array. Meant to be used with the ElDist array to
%find the padding at the front and back of the array to be a robust way to
%create two coefficient matrices

paddingFront = [];
paddingBack = [];

i = 1;
while isempty(paddingFront) || isempty(paddingBack)
    if ~isempty(ElDist{2,i}) && isempty(paddingFront)
        paddingFront = i;
    end

    if (isempty(ElDist{2,i+1}) && ~isempty(ElDist{2,i})) && isempty(paddingBack)
        paddingBack = i;
    end

    i = i+1;
end

end

