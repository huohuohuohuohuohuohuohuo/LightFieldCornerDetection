function [DeltaZ] = generateDeltaZ(obj, StartTotal, HV_flag)

cornerUL = [StartTotal.Corner4.cornerUL(1:2,1);1];
cornerUR = [StartTotal.Corner4.cornerUR(1:2,1);1];
cornerDR = [StartTotal.Corner4.cornerDR(1:2,1);1];
cornerDL = [StartTotal.Corner4.cornerDL(1:2,1);1];

ZcornerUL = StartTotal.Corner4.cornerUL(3,1);
ZcornerUR = StartTotal.Corner4.cornerUR(3,1);
ZcornerDR = StartTotal.Corner4.cornerDR(3,1);
ZcornerDL = StartTotal.Corner4.cornerDL(3,1);
if HV_flag == 'h'
    %corner_mid = [obj.HSubLine_corners.corner_mid;1];
    corner_left = [obj.HSubLine_corners.corner_left;1];
    corner_right = [obj.HSubLine_corners.corner_right;1];
    
    Pstart = cross(cross(cornerDL, cornerUL),cross(corner_left, corner_right));
    Pstart = Pstart./Pstart(end,1);
    Pend = cross(cross(cornerDR, cornerUR),cross(corner_left, corner_right));
    Pend = Pend./Pend(end,1);
    
    Pstart_Z = ZcornerUL + (...
        (Pstart(2,1) - cornerUL(2,1))/(cornerDL(2,1) - cornerUL(2,1))...
        )*(ZcornerDL - ZcornerUL);
     Pend_Z = ZcornerUR + (...
        (Pend(2,1) - cornerUR(2,1))/(cornerDR(2,1) - cornerUR(2,1))...
        )*(ZcornerDR - ZcornerUR);
    DeltaZ = ((corner_right(1,1) - corner_left(1,1))/(Pend(1,1) - Pstart(1,1)))*...
        (Pend_Z - Pstart_Z);
    % right点减去left点的Z的差 DeltaZ = Pright - Pleft;Pright = Pleft + DeltaZ;
end
if HV_flag == 'v'
    %corner_mid = [obj.VSubLine_corners.corner_mid;1];
    corner_up = [obj.VSubLine_corners.corner_up;1];
    corner_down = [obj.VSubLine_corners.corner_down;1];
    
    Pstart = cross(cross(cornerUR, cornerUL),cross(corner_up, corner_down));
    Pstart = Pstart./Pstart(end,1);
    Pend = cross(cross(cornerDR, cornerDL),cross(corner_up, corner_down));
    Pend = Pend./Pend(end,1);
    
     Pstart_Z = ZcornerUL + (...
        (Pstart(1,1) - cornerUL(1,1))/(cornerUR(1,1) - cornerUL(1,1))...
        )*(ZcornerUR - ZcornerUL);
     Pend_Z = ZcornerDL + (...
        (Pend(1,1) - cornerDL(1,1))/(cornerDR(1,1) - cornerDL(1,1))...
        )*(ZcornerDR - ZcornerDL);
    DeltaZ = ((corner_down(2,1) - corner_up(2,1))/(Pend(2,1) - Pstart(2,1)))*...
        (Pend_Z - Pstart_Z);
    %down的点减去up点的深度的差 DeltaZ = Pdown - Pup;Pdown = Pup + DeltaZ;
end
end