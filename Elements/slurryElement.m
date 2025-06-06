classdef slurryElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];

        %object properties
        type string = "slurry";

        %combustion flag, 0 = no combustion
        alpha double = 0;
        dist double = [0 0]; %product distance travelled [axial,radial]
        Q double = 0; %heat generation from combustion

        %Output Coefficients
        Aw double = [];
        Ap double = [];
        Ae double = [];
        An double = [];
        As double = [];

        %geometry data
        vol double = [];
        A double = [];
        x double = [];
        A_r double = [];

        %this term is related to the time derivative in the fluid
        t double = [];

        %tracking properties of the fluid
        rho double =[];
        c double =[];
        vel double = [];
        rho_old double =[] %previous time step's density
        KE double =[] %kinetic energy term for source due to time varying density
        ms double = []; %mass flow
    end
    
    methods
        function obj = slurryElement(i,j, globalInputs)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];
            obj = getNeighbours(obj);


            dist = (globalInputs.program.radialNodes +4) - obj.pos(1);
            R1 = globalInputs.screw.r0 + dist*globalInputs.screw.deltaR;
            
            obj.A = pi * ((R1+globalInputs.screw.deltaR)^2 - R1^2);
            obj.x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
            obj.vol = obj.A*obj.x;

            obj.A_r = R1*2*pi*obj.x;


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
            %iterating
            
            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %Combustion Process 
            if Tdist(obj.pos(1),obj.pos(2)) >= globalInputs.temperature.Tig
                obj.alpha = 1;
                % obj.Q = globalInputs.slurry.Q;
                obj.Q=1000;
            end

            %get resistance coefficients
            [cds_west, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_west,"axial",obj.pos,obj.alpha);
            [cds_east, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T_east,"axial",obj.pos,obj.alpha);

            cds_up = calculateCdsUp(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)),obj.alpha);
            cds_down = calculateCdsDown(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)),obj.alpha);

            %heat capacity of incoming fluid
            cps_in = calculateSlurryHeatCap(TPP,globalInputs,Tdist(obj.pos(1)-1,obj.pos(2)), obj.alpha);
            cps_out = calculateSlurryHeatCap(TPP, globalInputs, Tdist(obj.pos(1),obj.pos(2)), obj.alpha);

            %physical properties
            %burned density doesnt include the al2o3
            obj.rho = calculateSlurryDensity(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),0);
            % obj.rho = calculateSlurryDensity(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),obj.alpha);
            [obj.vel, obj.ms] = calculateSlurryVelocity(globalInputs,obj.pos,obj.rho,obj.alpha); %ax,radial
            
            %log cell heat capacity
            obj.c = cps_out;
            
            %initialize tho if it does not exist (remove me somehow)
            if isempty(obj.rho_old)
                obj.rho_old = obj.rho;
            end

            %kinetic energy change
            obj.KE = ((obj.rho-obj.rho_old)/globalInputs.program.timeStep)*(sqrt(obj.vel(1)^2+obj.vel(2)^2)^2/2)*obj.vol;
            obj.rho_old = obj.rho;


            % cds_west = 1e6;
            % cds_east = 1e6;
            % cds_down = 1e6;
            % cds_up = 1e6;

            %coefficients
            obj.Aw = (-1/cds_west - obj.vel(1)*obj.A*obj.rho*cps_in);
            obj.Ap = (+1/cds_west + 1/cds_east + 1/cds_up + 1/cds_down + obj.vel(1)*obj.A*obj.rho*cps_out + obj.vel(2)*obj.A_r*obj.rho*cps_out ); 
            obj.Ae = (-1/cds_east);

            obj.An = (-1/cds_up);

            obj.As = (-1/cds_down - obj.vel(2)*obj.A_r*obj.rho*cps_out );
        end

        function cds_up = calculateCdsUp(obj,TPP,globalInputs,ElDist,T, alpha)
            switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type

                case "innerPipe"
                    [cds, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos,alpha);
                    cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,T,k_s,obj.pos,alpha,"upper");

                    cds_up = (1/cds + 1/cvs)^(-1);
                case "slurry"
                    %parallel pipe conduction above
                    [cds, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",[obj.pos(1)-1,obj.pos(2)],alpha);

                    % cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",[obj.pos(1)-1,obj.pos(2)],obj.type); %-1 to get the inner pipe position

                    % cds_up = (1/cds + 1/cd_blade)^(-1);
                    cds_up = cds;

            end
        end

        function cds_down = calculateCdsDown(obj,TPP,globalInputs,ElDist,T,alpha)
                % switch ElDist{obj.neighbours(4,1),obj.neighbours(4,2)}.type
                % 
                %     case "slurry"
                %         [cds_down, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos,alpha);
                %     case "screw"
                        %parallel pipe conduction above
                        [cds, ~] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos,alpha);
    
                        cd_blade = calculateScrewConductionResistance(TPP, globalInputs, T,"radial",obj.pos,obj.type);
    
                        cds_down = (1/cds + 1/cd_blade)^(-1);

                % end
        end
        

    end
end

