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



        %Output Coefficients
        J0 double = [];
        J1 double = [];
        J2 double = [];
        K1 double = [];
        L1 double = [];
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
            %This function handles the updating of the screw node. It
            %is called upon initialization and when the solver is
            %iterating.

            %axial and radial pipe conduction resistances
            cdip = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial",[]);
            cdip_r = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)), "radial", obj.pos);



            %flange conduction resistance (axial only)
            cdf = calculateFlangeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial", []);
            
            cdsc_west = calculateScrewConductionResistance(TPP,globalInputs,T_west,"axial",[]);
            cdsc_east = calculateScrewConductionResistance(TPP,globalInputs,T_east,"axial",[]);

            cds_up = calculateCdsUp(obj, TPP, globalInputs, ElDist, Tdist(obj.pos(1),obj.pos(2)));
            
            %coefficients
            obj.F0 = (-1/cdsc_west);
            obj.F1 = (1/cdsc_west + 1/cdsc_east + 1/cdip);
            obj.F2 = (-1/cdsc_east);

            obj.G1 = (-1/cds_up);

 
        end


        function cds_up = calculateCdsUp(obj,TPP,globalInputs,ElDist,T)
            switch ElDist{obj.neighbours(2,1),obj.neighbours(2,2)}.type

                case "slurry"
                    [cds_up, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,T,"radial",obj.pos);
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

