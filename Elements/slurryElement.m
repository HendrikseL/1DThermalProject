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

        %combustion flag, 0 = no combustion
        COMBUSTION double = 0;

        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];

        %this term is related to the time derivative in the fluid
        t double = [];
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

            %Combustion Process 
                %check for combustion

            %get resistance coefficients
            [cds_west, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_west,"axial",obj.pos,obj.COMBUSTION);
            [cds_east, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_east,"axial",obj.pos,obj.COMBUSTION);

            cds_up = calculateCdsUp(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)),obj.COMBUSTION);
            cds_down = calculateCdsDown(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)),obj.COMBUSTION);

            %no combustion occurs
            if obj.COMBUSTION == 0 
                
                %heat capacity of incoming fluid
                cps_in = calculateSlurryHeatCap(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));
                cps_out = cps_in;

                rho = calculateSlurryDensity(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),obj.COMBUSTION);
            end

            dist = (globalInputs.program.radialNodes +4) - obj.pos(1);
            R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;
            
            A = pi * ((R1+globalInputs.screw.deltaR)^2 - R1^2);
            x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);

            vol = A*x;
            obj.t = (rho*cps_in*vol)/globalInputs.program.timeStep;

            %coefficients
            obj.A0 = (-1/cds_west - ms_ax*cps_in);

            obj.A1 = (1/cds_west + 1/cds_east + 1/cds_up + 1/cds_down +ms_ax*cps_out + ms_r*cps_in + obj.t);
            obj.A2 = (-1/cds_east);

            obj.B1 = (-1/cds_up);

            obj.C1 = (-1/cds_down - ms_r*cps_in);
        end


        function cds_up = calculateCdsUp(obj,TPP,globalInputs,ElDist,T, alpha)
            switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type

                case "innerPipe"
                    [cds, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos,alpha);
                    cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_s,obj.pos,alpha,"upper");

                    cds_up = (1/cds + 1/cvs)^(-1);
                case "slurry"
                    %parallel pipe conduction above
                    [cds, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",[obj.pos(1)-1,obj.pos(2)],alpha);

                    cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",[obj.pos(1)-1,obj.pos(2)],obj.type); %-1 to get the inner pipe position

                    cds_up = (1/cds + 1/cd_blade)^(-1);

            end
        end


        function cds_down = calculateCdsDown(obj,TPP,globalInputs,ElDist,T,alpha)
      
                [cds, k_slurry] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos,alpha);

                cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",obj.pos,obj.type);

                cds_down = (1/cds + 1/cd_blade)^(-1);
        end
        

    end
end

