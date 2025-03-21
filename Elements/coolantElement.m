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



        %Output Coefficients
        D0 double = [];
        D1 double = [];
        D2 double = [];
        E1 double = [];
        EE1 double = [];
    end
    
    methods
        function obj = coolantElement(i,j, globalInputs)
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
            
            [~, k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");

            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_south = (Tdist(obj.neighbours(4,1),obj.neighbours(4,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            [cdc_west, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_west,"axial");
            [cdc_east, ~] = calculateCoolantConductionResistance(TPP,globalInputs,T_east,"axial");

            cd_fins = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
            cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),k_cool);
            cd_op = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",[obj.pos(1)-1,obj.pos(2)]);

            cdc_up = (1/(cvc + cd_op) + 1/cd_fins)^(-1);
            cdc_down = (1/cvc + 1/cd_fins)^(-1);

            %heat capacities
            cpc_west = calculateCoolantHeatCap(TPP,globalInputs,T_west);
            cpc_south = calculateCoolantHeatCap(TPP,globalInputs,T_south);
            cpc = calculateCoolantHeatCap(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));
            
            %coefficients
            obj.D0 = (-1/cdc_west);
            obj.D1 = (1/cdc_west + 1/cdc_east + 1/cdc_up + 1/cdc_down + globalInputs.coolant.m_ax*cpc_west + globalInputs.coolant.m_r*cpc_south);
            obj.D2 = (-1/cdc_east + globalInputs.coolant.m_ax*cpc);

            obj.E1 = (-1/cdc_down +globalInputs.coolant.m_r*cpc);

            obj.EE1 = (-1/cdc_up);
        end
        

    end
end

