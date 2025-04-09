classdef slurryElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];
        radialPosition double =[]; 

        %object properties
        type string = "slurry";



        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];
    end
    
    methods
        function obj = slurryElement(i,j, globalInputs)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;
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
            obj.neighbours(4,:) = [obj.pos(1)+1, obj.pos(2)];
        end

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP,ElDist)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate massflow
            [ms_ax, ms_r] = calculateSlurryMassFlow(globalInputs,obj.radialPosition);
            
            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            [cds_west, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_west,"axial",obj.pos);
            [cds_east, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_east,"axial",obj.pos);

            cds_up = calculateCdsUp(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)));
            cds_down = calculateCdsDown(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)));

            %heat capacities
            cps_west = calculateSlurryHeatCap(TPP,globalInputs,T_west);
            cps = calculateSlurryHeatCap(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));
            
            %coefficients
            obj.A0 = (-1/cds_west - ms_ax*cps_west);

            obj.A1 = (1/cds_west + 1/cds_east + 1/cds_up + 1/cds_down +ms_ax*cps + ms_r*cps);
            obj.A2 = (-1/cds_east);

            obj.B1 = (-1/cds_up);

            obj.C1 = (-1/cds_down - ms_r*cps_west);
        end


        function cds_up = calculateCdsUp(obj,TPP,globalInputs,ElDist,T)
            switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type

                case "slurry"
                    [cds, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos);
                    cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_s,obj.pos);

                    cds_up = (1/cds + 1/cvs)^(-1);
                case "innerPipe"
                    %parallel pipe conduction above
                    [cds, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos);

                    cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",obj.pos);

                    cds_up = (1/cds + 1/cd_blade)^(-1);

            end
        end


        function cds_down = calculateCdsDown(obj,TPP,globalInputs,ElDist,T)
                switch ElDist{obj.neighbours(4,1),obj.neighbours(4,2)}.type

                case "slurry"
                    [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos);
                    hs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_slurry,obj.pos);

                    cds_down = (1/cds + 1/hs)^(-1);
                case "screw"
                    %parallel pipe conduction above
                    [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos);

                    cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",obj.pos);

                    cds_down = (1/cds + 1/cd_blade)^(-1);

                end
        end
        

    end
end

