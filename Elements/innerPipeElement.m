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

        %alpha flag
        alpha double = 0;

        %Output Coefficients
        %Output Coefficients
        Aw double = [];
        Ap double = [];
        Ae double = [];
        An double = [];
        As double = [];

        %geometry
        vol double =[];

        %cell properties
        rho double = 8000; %kg/m^3 for ss316
        KE double = 0;
        c double =[];
    end
    
    methods
        function obj = innerPipeElement(i,j, globalInputs, TPP, Tdist)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;


              x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
             obj.vol = x * (pi/4) * (globalInputs.innerPipe.OD^2 - globalInputs.innerPipe.ID^2);
        end
        
        function obj = getNeighbours(obj)
            %This function will determine the neighbours of a computational
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
            cdip = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial",obj.pos);
            cdip_r = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)), "radial", obj.pos);

            %fin conduction resistance
            cdfin = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial");
            cdfin_r = calculateFinsConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
            
            %slurry convection
            [~, k_s] = calculateSlurryConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial",obj.pos,obj.alpha);
            cvs = calculateSlurryConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),k_s,obj.pos,obj.alpha,"upper");

            %coolant convection
            [~, k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");
             cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),obj.pos);

            %calculate heat capacity
            obj.c = calculatePipeHeatCap(TPP,Tdist(obj.pos(1),obj.pos(2)));


            %coefficients
            obj.Aw = (-1/cdip);
            % obj.Ap = (1/(cdip+cdfin) +1/(cdip + cdfin_r) + 1/(cdip + cvs) + 1/(cvc));
            obj.Ap = (1/(cdip) +1/(cdip ) + 1/(cdip_r + cvs) + 1/(cvc));
            obj.Ae = (-1/cdip);

            obj.As = ( -1/(cdip_r + cvs));

            obj.An = (-1/cvc);

 
        end
       
    end
end

