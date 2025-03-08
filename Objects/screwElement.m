classdef screwElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        neighbours double = [];

        %object properties
        type string = "screw";



        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];
    end
    
    methods
        function obj = screwElement(i,j)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            %Updates the slurry node with initial values
            obj = updateCoefficients(obj);
        end
        
        function obj = getNeighbours(obj)
            %This function will deterine the neighbours of a computational
            %molecule
            %the order starts from the eastern neighbour and rotates
            %clockwise around forming the whole array
            %currently this is east,north,west,south

            %this function is meant to provide a framework for a future
            %unstrucutured grid

            %east
            obj.neighbours(1,:) = [obj.pos(1), obj.pos(2)-1];
            %north
            obj.neighbours(2,:) = [obj.pos(1)-1, obj.pos(2)];
            %west
            obj.neighbours(3,:) = [obj.pos(1), obj.pos(2)+1];
            %south
            obj.neighbours(4,:) = [obj.pos(1)+1, obj.pos(2)];
        end

        function obj = updateCoefficients(obj,Tdist,ElDist)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate thermophysical properties
            


            %update resistance values
            

            %calculate massflow

            obj.A0 = 1;
        end


        function cd_down = calculateCDDown(obj,Tdist,ElDist);

        end

        function cd_up = calculateCDUp(obj,Tdist,ElDist);

        end

        

    end
end

