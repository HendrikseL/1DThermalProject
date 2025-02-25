classdef slurryNode
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        n double =[]
        r double = []

        %material properties
        



        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];
    end
    
    methods
        function obj = slurryNode(i,j)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.n = i;
            obj.r = j;


            %Updates the slurry node with initial values
            obj = updateSlurry(obj);
        end
        
        function obj = updateSlurry(obj)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate thermophysical properties
            c = getConductionm(obj.T,s);


            %update resistance values
            

            %calculate massflow

            A0 = 1;
        end

    end
end

