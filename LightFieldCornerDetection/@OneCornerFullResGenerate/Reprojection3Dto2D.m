function OutputLineGroup = Reprojection3Dto2D(obj, InputLineGroup, Input3DPoints, HVflag)
%%%%%%%%%%
l_dis = obj.l_dis;
pixelPitch = obj.pixelPitch;

Point1_On3Dline = Input3DPoints.Point1; % obj.H3DPoints.initial.Point1
Point2_On3Dline = Input3DPoints.Point2; % obj.H3DPoints.initial.Point2

if HVflag == 'h'
    for i=1:InputLineGroup.k_num_left
        current_center = InputLineGroup.centerStack_left(:,i);
        %%%计算line上的两个3D点，在某个微透镜图像中的2D投影点的坐标。注意：该坐标为全局坐标，而每个
        %%%宏像素的linefeature的方程，使用的是以每个宏像素的中心为原点的局部坐标。
        %%%并且注意，这里方程中所有量的单位仍然是以pixel为单位，于是后面微透镜同sensor的距离，仍然要
        %%%换算成以pixel为单位，即l_dis/pixelPitch
        Point1_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point1_On3Dline(3,1))*...
            ([current_center;0] - Point1_On3Dline(1:3,1));
        Point2_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point2_On3Dline(3,1))*...
            ([current_center;0] - Point2_On3Dline(1:3,1));
        
        %%%计算局部坐标
        Point1_2Dlocal = Point1_On2Dline(1:2,1) - current_center;
        Point2_2Dlocal = Point2_On2Dline(1:2,1) - current_center;
        line_feature = cross([Point1_2Dlocal;1], [Point2_2Dlocal;1]);
        line_feature = line_feature./norm(line_feature(1:2,1)); % modified by JDY 20190227 %归一化
        OutputLineGroup.lineStack_left(:,i) = line_feature;
    end
    if InputLineGroup.k_num_left == 0
        OutputLineGroup.lineStack_left = [];
    end
    
    OutputLineGroup.centerStack_left = InputLineGroup.centerStack_left;
    OutputLineGroup.k_num_left = InputLineGroup.k_num_left;
    
    for i=1:InputLineGroup.k_num_right
        current_center = InputLineGroup.centerStack_right(:,i);
        %%%计算line上的两个3D点，在某个微透镜图像中的2D投影点的坐标。注意：该坐标为全局坐标，而每个
        %%%宏像素的linefeature的方程，使用的是以每个宏像素的中心为原点的局部坐标。
        %%%并且注意，这里方程中所有量的单位仍然是以pixel为单位，于是后面微透镜同sensor的距离，仍然要
        %%%换算成以pixel为单位，即l_dis/pixelPitch
        Point1_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point1_On3Dline(3,1))*...
            ([current_center;0] - Point1_On3Dline(1:3,1));
        Point2_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point2_On3Dline(3,1))*...
            ([current_center;0] - Point2_On3Dline(1:3,1));
        
        %%%计算局部坐标
        Point1_2Dlocal = Point1_On2Dline(1:2,1) - current_center;
        Point2_2Dlocal = Point2_On2Dline(1:2,1) - current_center;
        line_feature = cross([Point1_2Dlocal;1], [Point2_2Dlocal;1]);
        line_feature = line_feature./norm(line_feature(1:2,1)); % modified by JDY 20190227 %归一化
        OutputLineGroup.lineStack_right(:,i) = line_feature;
    end
    if InputLineGroup.k_num_right == 0
        OutputLineGroup.lineStack_right = [];
    end
    OutputLineGroup.centerStack_right = InputLineGroup.centerStack_right;
    OutputLineGroup.k_num_right = InputLineGroup.k_num_right;
end

if HVflag == 'v'
    for i=1:InputLineGroup.k_num_up
        current_center = InputLineGroup.centerStack_up(:,i);
        %%%计算line上的两个3D点，在某个微透镜图像中的2D投影点的坐标。注意：该坐标为全局坐标，而每个
        %%%宏像素的linefeature的方程，使用的是以每个宏像素的中心为原点的局部坐标。
        %%%并且注意，这里方程中所有量的单位仍然是以pixel为单位，于是后面微透镜同sensor的距离，仍然要
        %%%换算成以pixel为单位，即l_dis/pixelPitch
        Point1_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point1_On3Dline(3,1))*...
            ([current_center;0] - Point1_On3Dline(1:3,1));
        Point2_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point2_On3Dline(3,1))*...
            ([current_center;0] - Point2_On3Dline(1:3,1));
        
        %%%计算局部坐标
        Point1_2Dlocal = Point1_On2Dline(1:2,1) - current_center;
        Point2_2Dlocal = Point2_On2Dline(1:2,1) - current_center;
        line_feature = cross([Point1_2Dlocal;1], [Point2_2Dlocal;1]);
        line_feature = line_feature./norm(line_feature(1:2,1)); % modified by JDY 20190227 %归一化
        OutputLineGroup.lineStack_up(:,i) = line_feature;
    end
    if InputLineGroup.k_num_up == 0
        OutputLineGroup.lineStack_up = [];
    end
    OutputLineGroup.centerStack_up = InputLineGroup.centerStack_up;
    OutputLineGroup.k_num_up = InputLineGroup.k_num_up;
    
    for i=1:InputLineGroup.k_num_down
        current_center = InputLineGroup.centerStack_down(:,i);
        %%%计算line上的两个3D点，在某个微透镜图像中的2D投影点的坐标。注意：该坐标为全局坐标，而每个
        %%%宏像素的linefeature的方程，使用的是以每个宏像素的中心为原点的局部坐标。
        %%%并且注意，这里方程中所有量的单位仍然是以pixel为单位，于是后面微透镜同sensor的距离，仍然要
        %%%换算成以pixel为单位，即l_dis/pixelPitch
        Point1_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point1_On3Dline(3,1))*...
            ([current_center;0] - Point1_On3Dline(1:3,1));
        Point2_On2Dline = [current_center;0] + ((l_dis/pixelPitch)/Point2_On3Dline(3,1))*...
            ([current_center;0] - Point2_On3Dline(1:3,1));
        
        %%%计算局部坐标
        Point1_2Dlocal = Point1_On2Dline(1:2,1) - current_center;
        Point2_2Dlocal = Point2_On2Dline(1:2,1) - current_center;
        line_feature = cross([Point1_2Dlocal;1], [Point2_2Dlocal;1]);
        line_feature = line_feature./norm(line_feature(1:2,1)); % modified by JDY 20190227 %归一化
        OutputLineGroup.lineStack_down(:,i) = line_feature;
    end
    if InputLineGroup.k_num_down == 0
        OutputLineGroup.lineStack_down = [];
    end
    OutputLineGroup.centerStack_down = InputLineGroup.centerStack_down;
    OutputLineGroup.k_num_down = InputLineGroup.k_num_down;
end

end