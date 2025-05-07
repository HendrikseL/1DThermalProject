function temperatureFloodPlot(Tdist,settings,time,range,figType)
%reset colorbar or not
switch figType
    case 1
        fig = figure(1);
        x0=1;
        y0=2;
        width=6;
        height=6;
        set(gcf,'units','inches', 'position',[x0,y0,width,height])
        
        hold on
        axis ij
        imagesc(Tdist);
        
        %screw box
        boxSC_x = [0.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+0.5 0.5 0.5 ];
        boxSC_y = [length(Tdist(:,1))+0.5 length(Tdist(:,1))+0.5 length(Tdist(:,1))-0.5 length(Tdist(:,1))-0.5 length(Tdist(:,1))+0.5 ];
        plot(boxSC_x,boxSC_y,'k--',LineWidth=2);
        
        %inner pipe box
        boxIP_x = [0.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+0.5 0.5 0.5 ];
        boxIP_y = [length(Tdist(:,1))-settings(3)-0.5 length(Tdist(:,1))-settings(3)-0.5 length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-0.5 ];
        plot(boxIP_x,boxIP_y,'k--',LineWidth=2);
        
        %flange 1-2 box
        boxF12_x = [0.5 2.5 2.5 0.5 0.5 ];
        boxF12_y = [length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 0.5 0.5 length(Tdist(:,1))-settings(3)-1.5 ];
        plot(boxF12_x,boxF12_y,'r--',LineWidth=2);
        
        %flange 3-4 box
        boxF34_x = [length(Tdist(1,:))-1.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+.5 length(Tdist(1,:))-1.5 length(Tdist(1,:))-1.5 ];
        boxF34_y = [length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 0.5 0.5 length(Tdist(:,1))-settings(3)-1.5 ];
        plot(boxF34_x,boxF34_y,'r--',LineWidth=2);
        
        %outer pipe box
        boxOP_x = [2.5 length(Tdist(1,:))-1.5 length(Tdist(1,:))-1.5 2.5 2.5 ];
        boxOP_y = [1.5 1.5  2.5 2.5 1.5];
        plot(boxOP_x,boxOP_y,'k--',LineWidth=2);
        
        %outside
        %settings(1) = N
        %settings(2) = M
        for i = 0:1:settings(2)-1
            boxO_x = [3.5+settings(1)*i, 3.5+settings(1)-2+settings(1)*i, 3.5+settings(1)-2+settings(1)*i, 3.5+settings(1)*i, 3.5+settings(1)*i];
            boxO_y = [0.5 0.5  1.5 1.5 0.5];
            plot(boxO_x,boxO_y,'g--',LineWidth=2);
        
            %arrows for coolant inlet
            p = quiver(3+settings(1)*i,1,0,2,'k',LineWidth=2);
            p.AutoScale = "off";
        
            %arrows for coolant outlet
            p = quiver(4+settings(1)-2+settings(1)*i,3,0,-2,'k',LineWidth=2);
            p.AutoScale = "off";
        end
        
        colorlim = [range(1), range(2)];
        name = strcat("Reactor Temperature Distribution at Time: ", num2str(time*settings(4)*settings(5)));
        title(name ,"Interpreter", "latex", "Fontsize",16);
        clim(colorlim);
        c = colorbar;
        c.Location = "northoutside";
        
        ylabel("Radial Distance","Interpreter", "latex", "Fontsize",12)
        yticks([0  length(Tdist(:,1))])
        yticklabels([" "," "])
        xticks([0  length(Tdist(1,:))])
        xticklabels([" "," "])
        xlabel("Axial Distance","Interpreter","latex","FontSize", 12)
        
        hold off
    case 2
            fig = figure(1);
        x0=1;
        y0=2;
        width=6;
        height=6;
        set(gcf,'units','inches', 'position',[x0,y0,width,height])
        
        hold on
        axis ij
        imagesc(Tdist);
        
        %screw box
        boxSC_x = [0.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+0.5 0.5 0.5 ];
        boxSC_y = [length(Tdist(:,1))+0.5 length(Tdist(:,1))+0.5 length(Tdist(:,1))-0.5 length(Tdist(:,1))-0.5 length(Tdist(:,1))+0.5 ];
        plot(boxSC_x,boxSC_y,'k--',LineWidth=2);
        
        %inner pipe box
        boxIP_x = [0.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+0.5 0.5 0.5 ];
        boxIP_y = [length(Tdist(:,1))-settings(3)-0.5 length(Tdist(:,1))-settings(3)-0.5 length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-0.5 ];
        plot(boxIP_x,boxIP_y,'k--',LineWidth=2);
        
        %flange 1-2 box
        boxF12_x = [0.5 2.5 2.5 0.5 0.5 ];
        boxF12_y = [length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 0.5 0.5 length(Tdist(:,1))-settings(3)-1.5 ];
        plot(boxF12_x,boxF12_y,'r--',LineWidth=2);
        
        %flange 3-4 box
        boxF34_x = [length(Tdist(1,:))-1.5 length(Tdist(1,:))+0.5 length(Tdist(1,:))+.5 length(Tdist(1,:))-1.5 length(Tdist(1,:))-1.5 ];
        boxF34_y = [length(Tdist(:,1))-settings(3)-1.5 length(Tdist(:,1))-settings(3)-1.5 0.5 0.5 length(Tdist(:,1))-settings(3)-1.5 ];
        plot(boxF34_x,boxF34_y,'r--',LineWidth=2);
        
        %outer pipe box
        boxOP_x = [2.5 length(Tdist(1,:))-1.5 length(Tdist(1,:))-1.5 2.5 2.5 ];
        boxOP_y = [1.5 1.5  2.5 2.5 1.5];
        plot(boxOP_x,boxOP_y,'k--',LineWidth=2);
        
        %outside
        %settings(1) = N
        %settings(2) = M
        for i = 0:1:settings(2)-1
            boxO_x = [3.5+settings(1)*i, 3.5+settings(1)-2+settings(1)*i, 3.5+settings(1)-2+settings(1)*i, 3.5+settings(1)*i, 3.5+settings(1)*i];
            boxO_y = [0.5 0.5  1.5 1.5 0.5];
            plot(boxO_x,boxO_y,'g--',LineWidth=2);
        
            %arrows for coolant inlet
            p = quiver(3+settings(1)*i,1,0,2,'k',LineWidth=2);
            p.AutoScale = "off";
        
            %arrows for coolant outlet
            p = quiver(4+settings(1)-2+settings(1)*i,3,0,-2,'k',LineWidth=2);
            p.AutoScale = "off";
        end
        
        hold off
end

