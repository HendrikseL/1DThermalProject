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
        COMBUSTION double = [];

        %Output Coefficients
        D0 double = [];
        D1 double = [];
        D2 double = [];
        E1 double = [];
        EE1 double = [];

        %time derivative term
        t double  = [];
    end
    
    methods
        function obj = coolantElement(i,j, globalInputs)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj,globalInputs);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;
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
            
            [~, k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");

            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_south = (Tdist(obj.neighbours(4,1),obj.neighbours(4,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            [cdc_west, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_west,"axial");
            [cdc_east, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_east,"axial");

            cd_fins = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
            cvc_op = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),2);
            cvc_ip = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),4);
            cd_op = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",[obj.pos(1)-1,obj.pos(2)]);

            cdc_up = (1/(cvc_op + cd_op) + 1/cd_fins)^(-1);
            cdc_down = (1/cvc_ip + 1/cd_fins)^(-1);

            %heat capacities
            cpc_west = calculateCoolantHeatCap(TPP,globalInputs,T_west);
            cpc_south = calculateCoolantHeatCap(TPP,globalInputs,T_south);
            cpc = calculateCoolantHeatCap(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));
            
            %time derivative
            rho = lerp([TPP.waterCoolant(:,1),TPP.waterCoolant(:,4)],Tdist(obj.pos(1),obj.pos(2)));

             x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
             vol = x * (pi/4) * (globalInputs.outerPipe.ID^2 - globalInputs.innerPipe.OD^2);

            obj.t = (rho*cpc*vol)/globalInputs.program.timeStep;

            %coefficients
            obj.D0 = (-1/cdc_west);
             %west and south switched to current for now
            obj.D1 = (1/cdc_west + 1/cdc_east + 1/cdc_up + 1/cdc_down - globalInputs.coolant.m_ax*cpc - globalInputs.coolant.m_r*cpc + obj.t);
            obj.D2 = (-1/cdc_east + globalInputs.coolant.m_ax*cpc);

            obj.E1 = (-1/cdc_down +globalInputs.coolant.m_r*cpc);

            obj.EE1 = (-1/cdc_up);
        end
        

    end
end

