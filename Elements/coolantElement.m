classdef coolantElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];
        radialPosition double =[]; 

        %object properties
        type string = "coolant";

        %combustion flag, present here for uniformity.
        %will always be empty
        alpha double = [];

        %Output Coefficients
        Aw double = [];
        Ap double = [];
        Ae double = [];
        An double = [];
        As double = [];

        %geometry
        vol double =[];
        A double = [];
        x double =[];
        A_r double = [];

        %cell properties
        rho double = [];
        KE double = 0;
        c double =[];
        vel double = [];

    end
    
    methods
        function obj = coolantElement(i,j, globalInputs, TPP, Tdist)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj,globalInputs);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;

             obj.x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
             obj.A = (pi/4) * (globalInputs.outerPipe.ID^2 - globalInputs.innerPipe.OD^2);
             obj.vol = obj.x * obj.A;

             obj.A_r = obj.x*pi*globalInputs.outerPipe.ID;
        end
        
        function obj = getNeighbours(obj,globalInputs)
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


            %check for boundaries (tc_out and tc_in)
            if mod((obj.pos(2) - 2),globalInputs.program.N) == 1
                %western neighbour is actually tc_in
                obj.neighbours(1,:) = [obj.pos(1)-2, obj.pos(2)];
            elseif mod((obj.pos(2) - 2),globalInputs.program.N) == 0
                %eastern neighbour is actually tc_out
                obj.neighbours(3,:) = [obj.pos(1)-2, obj.pos(2)];
            end

        end

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP,ElDist)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.
            

            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            % T_south = (Tdist(obj.neighbours(4,1),obj.neighbours(4,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            [cdc_west, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_west,"axial");
            [cdc_east, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_east,"axial");

            cd_fins = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
            cvc_op = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),2);
            cvc_ip = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),4);
            cd_op = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",[obj.pos(1)-1,obj.pos(2)]);

            cdc_up = (1/(cvc_op + cd_op) + 1/cd_fins)^(-1);
            cdc_down = (1/cvc_ip + 1/cd_fins)^(-1);

            

            %cell properties
            obj.rho = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,4)],Tdist(obj.pos(1),obj.pos(2)));
            obj.c = calculateCoolantHeatCap(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));

            %calculate coolant velocity
            obj.vel(1) = globalInputs.coolant.m_ax / (obj.A * obj.rho);
            obj.vel(2) = globalInputs.coolant.m_r / (obj.A_r* obj.rho);

            %coefficients
            obj.Aw= (-1/cdc_west);
             %west and south switched to current for now
            obj.Ap = (1/cdc_west + 1/cdc_east + 1/cdc_up + 1/cdc_down + obj.vel(1)*obj.A*obj.rho*obj.c + obj.vel(2)*obj.A_r*obj.rho*obj.c );
            obj.Ae = (-1/cdc_east - obj.vel(1)*obj.A*obj.rho*obj.c);

            obj.As = (-1/cdc_down - obj.vel(2)*obj.A_r*obj.rho*obj.c);

            obj.An = (-1/cdc_up);
        end
        

    end
end

