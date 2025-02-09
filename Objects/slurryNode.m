classdef slurryNode
    %slurry node object.

    properties
        %material properties
        



        %Output Coefficients
        A0 double = [];
        A1 double = [];
        A2 double = [];
        B1 double = [];
        C1 double = [];
    end
    
    methods
        function obj = slurryNode()
            %Constructs a slurry type temperature node

            %Updates the slurry node with initial values
            obj = updateSlurry(obj);
        end
        
        function obj = updateSlurry(obj)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate thermophysical properties
            obj = getThermophysicalProperties(obj);


            %update resistance values
            cd

            %calculate massflow

            A0 = 1;
        end

        function obj = getThermophysicalProperties(obj)
        %Updates theromphysical properties by looking through lookup tables
        %or empirical correlations


        end
    end
end

