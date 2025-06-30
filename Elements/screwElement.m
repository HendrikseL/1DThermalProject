classdef screwElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];
        radialPosition double = [];

        %object properties
        type string = "screw";

        %alpha flag, used for slurry, 0 = no alpha
        alpha double = 0;

        %Output Coefficients
        Aw double = [];
        Ap double = [];
        Ae double = [];
        An double = [];
        As double = 0 % no southern neighbour;

        %cell geometry
        vol double =[];

        %cell properties
        rho double = 8220; %kg/m^3 for haselloyX
        KE double = 0;
        c double =[];
    end
    
    methods
        function obj = screwElement(i,j, globalInputs, TPP, Tdist)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;


            x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
            obj.vol = x * (pi/4)*globalInputs.screw.d^2;
        end
        
        function obj = getNeighbours(obj)
            %This function will deterine the neighbours of a computational
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
            obj.neighbours(4,:) = [0, 0]; %no neighbour
        end

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP,ElDist)
            %This function handles the updating of the screw node. It
            %is called upon initialization and when the solver is
            %iterating.
            cds = calculateSlurryConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",obj.pos,obj.alpha);
            
            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            cdsc_west = calculateScrewConductionResistance(TPP,globalInputs,T_west,"axial",obj.pos,obj.type);
            cdsc_east = calculateScrewConductionResistance(TPP,globalInputs,T_east,"axial",obj.pos,obj.type);

            % [cds, ~] = calculateSlurryConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",obj.pos,obj.alpha);

            %calculate cell heat capacity
            obj.c = calculateScrewHeatCap(TPP,Tdist(obj.pos(1),obj.pos(2)));


            %coefficients
            obj.Aw = (-1/cdsc_west);
            obj.Ap = (1/cdsc_west + 1/cdsc_east + 1/cds);
            obj.Ae = (-1/cdsc_east);

            obj.An = (-1/cds);

 
        end
        

    end
end

