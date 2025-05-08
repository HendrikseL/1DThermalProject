classdef innerPipeElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];
        radialPosition double =[]; 

        %object properties
        type string = "innerPipe";

        %combustion flag
        COMBUSTION double = 0;

        %Output Coefficients
        J0 double = [];
        J1 double = [];
        J2 double = [];
        K1 double = [];
        L1 double = [];

        %time derivative term
        t double = [];
    end
    
    methods
        function obj = innerPipeElement(i,j, globalInputs)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;
        end
        
        function obj = getNeighbours(obj)
            %This function will determine the neighbours of a computational
            %molecule
            %the order starts from the eastern neighbour and rotates
            %clockwise around forming the whole array
            %currently this is west,north,east,south

            %this function is meant to provide a framework for a future
            %unstrucutured grid

            %west
            obj.neighbours(1,:) = [obj.pos(1), obj.pos(2)-1];
            %north
            obj.neighbours(2,:) = [obj.pos(1)-1, obj.pos(2)];
            %eastt
            obj.neighbours(3,:) = [obj.pos(1), obj.pos(2)+1];
            %south
            obj.neighbours(4,:) = [obj.pos(1)+1, obj.pos(2)];
        end

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP,ElDist)
            %This function handles the updating of the screw node. It
            %is called upon initialization and when the solver is
            %iterating.

            %axial and radial pipe conduction resistances
            cdip = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial",obj.pos);
            cdip_r = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)), "radial", obj.pos);

            %fin conduction resistance
            cdfin = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial");
            cdfin_r = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
            
            %slurry convection
            [~, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",obj.pos,obj.COMBUSTION);
            cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),k_s,obj.pos,obj.COMBUSTION,"upper");

            %coolant convection
            [~, k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
             cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),obj.pos);


             c = calculatePipeHeatCap(TPP,Tdist(obj.pos(1),obj.pos(2)));
             rho_ss = 8000; %kg/m^3

              x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
             vol = x * (pi/4) * (globalInputs.innerPipe.OD^2 - globalInputs.innerPipe.ID^2);

            obj.t = (rho_ss*c*vol)/globalInputs.program.timeStep;

            %coefficients
            obj.J0 = (-1/cdip);
            % obj.J1 = (1/(cdip+cdfin) +1/(cdip + cdfin_r) + 1/(cdip + cvs) + 1/(cvc));
            obj.J1 = (1/(cdip) +1/(cdip ) + 1/(cdip_r + cvs) + 1/(cvc) + obj.t);
            obj.J2 = (-1/cdip);

            obj.K1 = ( -1/(cdip_r + cvs));

            obj.L1 = (-1/cvc);

 
        end
       
    end
end

