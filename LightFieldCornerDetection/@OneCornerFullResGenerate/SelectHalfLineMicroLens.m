function SelectHalfLineMicroLens(obj,d_img)
if obj.HSubLine_corners.corner_left(1,1)~=0 && obj.HSubLine_corners.corner_left(2,1)~=0
    LeftTh = abs( obj.HSubLine_corners.corner_left(1,1) - obj.HSubLine_corners.corner_mid(1,1))...
        * d_img / 2;
    if ~isempty(obj.HLine.original.centerStack_left)
        Temp = obj.HLine.original.centerStack_left(1,:);
        Index = find( Temp < obj.HSubLine_corners.corner_mid(1,1)  * d_img - LeftTh);
        obj.HNCCGroup_left(:,Index) = [];
        obj.HLine.original.centerStack_left(:,Index) = [];
        obj.HLine.original.lineStack_left(:,Index) = [];
        obj.HLine.original.k_num_left = size( obj.HLine.original.lineStack_left, 2);
    end
end

if obj.HSubLine_corners.corner_right(1,1)~=0 && obj.HSubLine_corners.corner_right(2,1)~=0
    RightTh = abs( obj.HSubLine_corners.corner_right(1,1) - obj.HSubLine_corners.corner_mid(1,1))...
        * d_img / 2;
    if ~isempty(obj.HLine.original.centerStack_right)
        Temp = obj.HLine.original.centerStack_right(1,:);
        Index = find( Temp > obj.HSubLine_corners.corner_mid(1,1)  * d_img + RightTh);
        obj.HNCCGroup_right(:,Index) = [];
        obj.HLine.original.centerStack_right(:,Index) = [];
        obj.HLine.original.lineStack_right(:,Index) = [];
        obj.HLine.original.k_num_right = size( obj.HLine.original.lineStack_right, 2);
    end
end

if obj.VSubLine_corners.corner_up(1,1)~=0 && obj.VSubLine_corners.corner_up(2,1)~=0
    UpTh = abs( obj.VSubLine_corners.corner_up(2,1) - obj.VSubLine_corners.corner_mid(2,1))...
        * d_img / 2;
    if ~isempty(obj.VLine.original.centerStack_up)
        Temp = obj.VLine.original.centerStack_up(2,:);
        Index = find( Temp < obj.VSubLine_corners.corner_mid(2,1)  * d_img - UpTh);
        obj.VNCCGroup_up(:,Index) = [];
        obj.VLine.original.centerStack_up(:,Index) = [];
        obj.VLine.original.lineStack_up(:,Index) = [];
        obj.VLine.original.k_num_up = size( obj.VLine.original.lineStack_up, 2);
    end
end

if obj.VSubLine_corners.corner_down(1,1)~=0 && obj.VSubLine_corners.corner_down(2,1)~=0
    DownTh = abs( obj.VSubLine_corners.corner_down(2,1) - obj.VSubLine_corners.corner_mid(2,1))...
        * d_img / 2;
    if ~isempty(obj.VLine.original.centerStack_down)
        Temp = obj.VLine.original.centerStack_down(2,:);
        Index = find( Temp > obj.VSubLine_corners.corner_mid(2,1)  * d_img + DownTh);
        obj.VNCCGroup_down(:,Index) = [];
        obj.VLine.original.centerStack_down(:,Index) = [];
        obj.VLine.original.lineStack_down(:,Index) = [];
        obj.VLine.original.k_num_down = size( obj.VLine.original.lineStack_down, 2);
    end
end
end