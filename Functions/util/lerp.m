%Inputs:
%arr - mx2 array of values to be interpolated
%xdesired - desired value for interpoation
function ydesired = lerp(arr, xdesired)
    ydesired = [];
        %check for lower than first or higher than last
    if xdesired < arr(1,1)
        ydesired = arr(1,2);
    elseif xdesired > arr(end,1)
        ydesired = arr(end,2);
    else
        i =1;
        while isempty(ydesired) && i < length(arr(:,1))
            if  xdesired < arr(i+1,1) && xdesired >= arr(i,1) 
                ydesired = (xdesired - arr(i,1)) * ( (arr(i+1,2) - arr(i,2)) / (arr(i+1,1) - arr(i,1)) ) + arr(i,2); 
            end
            i = i +1;
        end
    end

end

