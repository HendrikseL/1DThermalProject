classdef slurryNode
    %slurry node object.

    properties
        Property1
    end
    
    methods
        function obj = slurryNode(inputArg1,inputArg2)
            %Constructs a slurry type temperature node

            %Updates the slurry node with initial values
            obj = updateSlurry(obj);
        end
        
        function obj = updateSlurry(obj)
            %This function handles the updating of the slurry node. It
            %is called upon initialization and when the solver is
            %iterating.

            %calculate thermophysical properties
            obj = get
            %update resistance values
            cd

            %calculate massflow

            A0 = 
        end
    end
end

