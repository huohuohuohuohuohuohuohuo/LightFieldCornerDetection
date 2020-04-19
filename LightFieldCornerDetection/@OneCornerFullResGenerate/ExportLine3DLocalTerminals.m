function ExportLine3DLocalTerminals(obj, Point1_On3Dline, Point2_On3Dline, d_img, HVflag)
%%% Line in raw image
if HVflag == 'h'
    if obj.HSubLine_corners.corner_right(1,1)~=0 && obj.HSubLine_corners.corner_right(2,1)~=0
        %use half line
        %RawSelected_corner_1 = (obj.HSubLine_corners.corner_mid + obj.HSubLine_corners.corner_right) / 2 * d_img;
        
        %use whole line
        RawSelected_corner_1 = obj.HSubLine_corners.corner_right * d_img;
    else
         RawSelected_corner_1 = obj.HSubLine_corners.corner_mid * d_img;
    end
    
    if obj.HSubLine_corners.corner_left(1,1)~=0 && obj.HSubLine_corners.corner_left(2,1)~=0
        %use half line
        %RawSelected_corner_2 = (obj.HSubLine_corners.corner_mid + obj.HSubLine_corners.corner_left) / 2 * d_img;
        
        %use whole line
        RawSelected_corner_2 = obj.HSubLine_corners.corner_left * d_img;
    else
         RawSelected_corner_2 = obj.HSubLine_corners.corner_mid * d_img;
    end

    Point_1 = zeros(3,1);
    Point_1(1,1) = RawSelected_corner_2(1,1);
    lambda_1 = (Point_1(1,1) - Point1_On3Dline(1,1))/(Point2_On3Dline(1,1) - Point1_On3Dline(1,1));
    Point_1 = Point1_On3Dline + lambda_1*(Point2_On3Dline - Point1_On3Dline);
    
    Point_2 = zeros(3,1);
    Point_2(1,1) = RawSelected_corner_1(1,1);
    lambda_2 = (Point_2(1,1) - Point1_On3Dline(1,1))/(Point2_On3Dline(1,1) - Point1_On3Dline(1,1));
    Point_2 = Point1_On3Dline + lambda_2*(Point2_On3Dline - Point1_On3Dline);
    obj.H3DPoints.initial.Point1 = Point_1;
    obj.H3DPoints.initial.Point2 = Point_2;
else
    if obj.VSubLine_corners.corner_up(1,1)~=0 && obj.VSubLine_corners.corner_up(2,1)~=0
        %use half line
        %RawSelected_corner_2 = (obj.VSubLine_corners.corner_mid + obj.VSubLine_corners.corner_up) / 2 * d_img;
        
        %use whole line
        RawSelected_corner_2 =  obj.VSubLine_corners.corner_up * d_img;
    else
        RawSelected_corner_2 = obj.VSubLine_corners.corner_mid * d_img;
    end
    
    if obj.VSubLine_corners.corner_down(1,1)~=0 && obj.VSubLine_corners.corner_down(2,1)~=0
        %use half line
        %RawSelected_corner_1 = (obj.VSubLine_corners.corner_mid + obj.VSubLine_corners.corner_down) / 2 * d_img;
        
        %use whole line
        RawSelected_corner_1 = obj.VSubLine_corners.corner_down * d_img;
    else
        RawSelected_corner_1 = obj.VSubLine_corners.corner_mid * d_img;
    end
    
    Point_1 = zeros(3,1);
    Point_1(2,1) = RawSelected_corner_2(2,1);
    lambda_1 = (Point_1(2,1) - Point1_On3Dline(2,1))/(Point2_On3Dline(2,1) - Point1_On3Dline(2,1));
    Point_1 = Point1_On3Dline + lambda_1*(Point2_On3Dline - Point1_On3Dline);
    
    Point_2 = zeros(3,1);
    Point_2(2,1) = RawSelected_corner_1(2,1);
    lambda_2 = (Point_2(2,1) - Point1_On3Dline(2,1))/(Point2_On3Dline(2,1) - Point1_On3Dline(2,1));
    Point_2 = Point1_On3Dline + lambda_2*(Point2_On3Dline - Point1_On3Dline);
    obj.V3DPoints.initial.Point1 = Point_1;
    obj.V3DPoints.initial.Point2 = Point_2;
    
  %  plot([Point_1(1,1), Point_2(1,1)],[Point_1(2,1), Point_2(2,1)],'r-','LineWidth',1);
    
end
end