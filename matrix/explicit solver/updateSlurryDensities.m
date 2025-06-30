function ElVec = updateSlurryDensities(globalInputs,TPP,ElVec,Tvec,idx_s)
%updates all densitys using new pressure field and old temperature field.

i = 1;
while i < length(idx_s)
    ElVec{idx_s(i)}.rho_old = ElVec{idx_s(i)}.rho;
    ElVec{idx_s(i)}.rho = calculateSlurryDensity(TPP,globalInputs,Tvec(idx_s(i)),ElVec{idx_s(i)}.alpha,ElVec{idx_s(i)}.P);

    i = i +1;
end

end

