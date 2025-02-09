function cp_s = calculateSlurryHeatCap(m_al, cp_al, m_h20, cp_h20)
%Calculates the mass averaged specific heat of the slurry

%inputs: m_al --> mass of aluminum in the slurry
%        m_h2o --> mass of water in the slurry
%        cp_al --> specific heat of aluminum
%        cp_h2o --> specific heat of water

cp_s = (1 / (m_al + m_h2o)) * (ms_al *cp_al + m_h2o*cp_h20);

end