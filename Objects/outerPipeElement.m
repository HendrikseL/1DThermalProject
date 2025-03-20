classdef outerPipeElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];
        radialPosition double =[]; 

        %object properties
        type string = "outerPipe";



        %Output Coefficients
        F0 double = [];
        F1 double = [];
        F2 double = [];
        G1 double = [];
    end
    
    methods
        function obj = outerPipeElement(i,j, globalInputs)
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
        end

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP,ElDist)
            %This function handles the updating of the screw node. It
            %is called upon initialization and when the solver is
            %iterating.
            cdsc = calculateScrewConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)));
            
            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            cdsc_west = calculateScrewConductionResistance(TPP,globalInputs,T_west);
            cdsc_east = calculateScrewConductionResistance(TPP,globalInputs,T_east);

            cds_up = calculateCdsUp(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)));
            
            %coefficients
            obj.F0 = (-1/cdsc_west);
            obj.F1 = (1/cdsc_west + 1/cdsc_east + 1/cdsc);
            obj.F2 = (-1/cdsc_east);

            obj.G1 = (-1/cds_up);

 
        end


        function cds_up = calculateCdsUp(obj,TPP,globalInputs,ElDist,T)
            switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type

                case "slurry"
                    [cds_up, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T);
            end
        end


        function cds_down = calculateCdsDown(obj,TPP,globalInputs,ElDist,T)
            %                     switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type
            % 
            %     case "slurry"
            %         [cds_up, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T);
            % end

            % end
        end
        

    end
end

