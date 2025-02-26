classdef slurryElement
    %slurry node object.

    properties
        %position information
        %n -> axial position, r-> radial position
        pos double = [];
        

        %material properties



        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];
    end
    
    methods
        function obj = slurryElement(i,j)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];


            %Updates the slurry node with initial values
            obj = updateSlurry(obj);
        end
        
        function obj = updateSlurry(obj,Tdist)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate thermophysical properties
            % c = getConductionm(,s);


            %update resistance values
            

            %calculate massflow

            obj.A0 = 1;
        end

    end
end

