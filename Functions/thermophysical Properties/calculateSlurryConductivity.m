function k_s = calculateSlurryConductivity(phi, k_al, k_h2o);
%Calculate the thermal comnductivity of the slurry

%Input: phi --> volume fraction of solid aluminum
%       k_al --> thermal conductivity of aluminum
%       k_h2o --> thermal conductivity of water

k_s = phi*k_al + (1-phi)*k_h20;
end