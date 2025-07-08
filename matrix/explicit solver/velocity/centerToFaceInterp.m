function slurryVel_face = centerToFaceInterp(Av, ElVec, slurryPositionMap, slurryVel, slurryP, slurryPgrad)
%This is the Rhie and Chow scheme to prevent checkerboarding of the
%pressure field, derived form the formulation by:
    %Bartholomew et al, "Unified Formulation of the momentum-weighted
    %interpolation for collocated variable arrangements", Journal of
    %Computational Physics, 2018.

%inputs face velocity field and outputs cell center velocity using pressure
%gradient to correct interpolation.
slurryVel_face = zeros(length(slurryVel),1);
i = 1;
while isempty(ElVec{slurryPositionMap(i,3)})
    %0's to indicate empty neighbour indices
    neighboursIn= [0,0;0,0;slurryPositionMap(i,1),slurryPositionMap(i,2)+1];
    neighbours = findNeighboursPosition(neighboursIn,slurryPositionMap,3);
    %inverserse distance weighting for a grid with equal length grid cells
    l = 0.5;

    Pgrad = (slurryP(i) - slurryP(neighbours(3)))/ElVec{slurryPositionMap(neighbours(3),3)}.x;
    interpPgrad = l*slurryPgrad(i) + l*slurryPgrad(3);
    slurryVel_face(i) = l*slurryVel(i) + l*slurryVel(neighbours(3)) - (1/Av(i,i)) * (Pgrad-interpPgrad);

    i = i+1;
end

while ~isempty(ElVec{slurryPositionMap(i,3)})
    neighbours = findNeighboursPosition(ElVec{slurryPositionMap(i,3)}.neighbours,slurryPositionMap,3);
    %inverserse distance weighting 
    % l = ElVec{slurryPositionMap(i,3)}.x / (ElVec{slurryPositionMap(i,3)}.x + ElVec{slurryPositionMap(neighbours(3),3)}.x); 
    l = 0.5;
    Pgrad = (slurryP(i) - slurryP(neighbours(3)))/ElVec{slurryPositionMap(i,3)}.x;
    interpPgrad = l*slurryPgrad(i) + l*slurryPgrad(3);
    slurryVel_face(i) = l*slurryVel(i) + l*slurryVel(neighbours(3)) - (1/Av(i,i)) * (Pgrad-interpPgrad);

    i = i+1;
end

while i <= length(slurryVel)
     nMax = 1;
     neighbour = findNeighboursPosition([slurryPositionMap(i,1),slurryPositionMap(i,2)-1], slurryPositionMap, nMax);


    slurryVel_face(i) = slurryVel_face(neighbour(1));
     i = i+1;
end

end

