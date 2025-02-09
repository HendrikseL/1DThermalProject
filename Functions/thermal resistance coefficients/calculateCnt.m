function cnt = calculateCnt(h, A)
%Calculates the contact resistance

%Input: h --> Conduction heat transfer coefficient
%       A --> cross sectional contact area

cnt = 1/(h*A);
end

