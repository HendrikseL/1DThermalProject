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

        %combustion flag, present here for uniformity.
        %will always be empty
        COMBUSTION double = [];

        %Output Coefficients
        H0 double = [];
        H1 double = [];
        H2 double = [];
        I1 double = [];
        II1 double = [];

        %geometry
        vol double =[];

        %cell properties
        rho double = 8000; %kg/m^3 for ss316
        c double =[];

    end
    
    methods
        function obj = outerPipeElement(i,j, globalInputs)
            %Constructs a slurry type temperature node

            %track position of slurry node
            obj.pos = [i,j];

            obj = getNeighbours(obj);
            obj.radialPosition = globalInputs.program.radialNodes+5  -i;

             x = globalInputs.screw.l /(globalInputs.program.N*globalInputs.program.M);
             obj.vol = x * (pi/4) * (globalInputs.outerPipe.OD^2 - globalInputs.outerPipe.ID^2);
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

        function obj = updateCoefficients(obj,Tdist, globalInputs, TPP, ElDist)
            %This function handles the updating of the screw node. It
            %is called upon initialization and when the solver is
            %iterating.
            cdop = calculatePipeConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial",obj.pos);

            [~,k_cool] = calculateCoolantConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"axial");
            cvc = calculateCoolantConvectiveResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),obj.pos);
            
            %temperatures, averaged between nodes 
            T_west = (Tdist(obj.neighbours(1,1),obj.neighbours(1,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;
            T_east = (Tdist(obj.neighbours(3,1),obj.neighbours(3,2)) + Tdist(obj.pos(1),obj.pos(2)))/2;

            %get resistance coefficients
            cdop_west = calculatePipeConductionResistance(TPP,globalInputs,T_west,"axial",obj.pos);
            cdop_east = calculatePipeConductionResistance(TPP,globalInputs,T_east,"axial",obj.pos);

            %natural convection
            cv_nat =  calculateNaturalConvectionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"outerPipe",obj.pos);

            %insulation
            cd_ins = calculateInsulationConductionResistance(TPP,globalInputs,Tdist(obj.pos(1),obj.pos(2)),"radial");

            %coefficients
            if obj.pos(2) == 3 %touching flange on left
                R_west = (1/(cdop_west+calculateFlangeContactResistance(globalInputs,"pipe",[1,2])));
            else
                R_west = (1/cdop_west);
            end

            if obj.pos(2) == length(ElDist(1,:))-2 %touching flange on left
                posF3 = [1, 3+globalInputs.program.N*globalInputs.program.M];
                R_east = (1/(cdop_east+calculateFlangeContactResistance(globalInputs,"pipe",posF3)));
            else
                R_east = (1/cdop_east);
            end


            %calculate heat capacity
            obj.c = calculatePipeHeatCap(TPP,Tdist(obj.pos(1),obj.pos(2)));
            
            obj.H0 = -R_west;
            obj.H2 = -R_east;
            obj.H1 = (R_west + R_east + 1/(cvc + cdop) + 1/(cv_nat + cd_ins));
           
            obj.I1 = (-1/(cvc + cdop));

            obj.II1 = (-1/(cv_nat + cd_ins));
        end


    end
end

