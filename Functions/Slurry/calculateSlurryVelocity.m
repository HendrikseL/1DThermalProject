function vel = calculateSlurryVelocity(globalInputs, rho)
%calculates slurry velocity from known density

vel = globalInputs.slurry.ms/ ((pi/4)*(globalInputs.innerPipe.ID^2-globalInputs.screw.d^2) * rho);

end

