function Plot_LineFeature(obj, LineGroup, HVflag, color)
radius = obj.radius;
b=[-radius+0.5,radius-0.5];
%----------------

if HVflag == 'h'
    if LineGroup.k_num_left
        k_num_left = LineGroup.k_num_left;
        lineStack_left = LineGroup.lineStack_left;
        centerStack_left = LineGroup.centerStack_left;
        
        for i = 1:k_num_left
            boundary=[b;-(b*lineStack_left(1,i)+lineStack_left(3,i))/lineStack_left(2,i)];
            plot(boundary(1,:)+centerStack_left(1,i),boundary(2,:)+centerStack_left(2,i),color,'LineWidth',1);
        end
        plot(centerStack_left(1,1:k_num_left),centerStack_left(2,1:k_num_left),'r.','MarkerSize',5);
    end
    
    if LineGroup.k_num_right
        k_num_right = LineGroup.k_num_right;
        lineStack_right = LineGroup.lineStack_right;
        centerStack_right = LineGroup.centerStack_right;
        
        for i = 1:k_num_right
            boundary=[b;-(b*lineStack_right(1,i)+lineStack_right(3,i))/lineStack_right(2,i)];
            plot(boundary(1,:)+centerStack_right(1,i),boundary(2,:)+centerStack_right(2,i),color,'LineWidth',1);
        end
        plot(centerStack_right(1,1:k_num_right),centerStack_right(2,1:k_num_right),'r.','MarkerSize',5);
    end
end

if HVflag == 'v'
    if LineGroup.k_num_up
        k_num_up = LineGroup.k_num_up;
        lineStack_up = LineGroup.lineStack_up;
        centerStack_up = LineGroup.centerStack_up;
        for i=1:k_num_up
            boundary=[-(b*lineStack_up(2,i)+lineStack_up(3,i))/lineStack_up(1,i);b];
            plot(boundary(1,:)+centerStack_up(1,i),boundary(2,:)+centerStack_up(2,i),color,'LineWidth',1);
        end
        plot(centerStack_up(1,1:k_num_up),centerStack_up(2,1:k_num_up),'r.','MarkerSize',5);
    end
    
    if LineGroup.k_num_down
        k_num_down = LineGroup.k_num_down;
        lineStack_down = LineGroup.lineStack_down;
        centerStack_down = LineGroup.centerStack_down;
        for i=1:k_num_down
            boundary=[-(b*lineStack_down(2,i)+lineStack_down(3,i))/lineStack_down(1,i);b];
            plot(boundary(1,:)+centerStack_down(1,i),boundary(2,:)+centerStack_down(2,i),color,'LineWidth',1);
        end
        plot(centerStack_down(1,1:k_num_down),centerStack_down(2,1:k_num_down),'r.','MarkerSize',5);
    end
end

end