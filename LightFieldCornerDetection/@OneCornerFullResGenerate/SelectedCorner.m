function SelectedCorner(obj, FullResObj)
%%% 局部要使用的数据结构初始化
lineStack_h_left = zeros(3, 3000);
lineStack_h_right = zeros(3, 3000);

lineStack_v_up = zeros(3, 3000);
lineStack_v_down = zeros(3, 3000);

centerStack_h_left = zeros(2, 3000);
centerStack_h_right = zeros(2, 3000);

centerStack_v_up = zeros(2, 3000);
centerStack_v_down = zeros(2, 3000);

MaxNCC_h_left = zeros(1,3000);
MaxNCC_h_right = zeros(1,3000);

MaxNCC_v_up = zeros(1,3000);
MaxNCC_v_down = zeros(1,3000);

k_h_left = 0;k_h_right = 0; k_v_up = 0; k_v_down = 0; % index of each lineStack
%%%
for h_idx = 1:size(FullResObj.LineFeatureInfo.world_h, 2)
    if FullResObj.LineFeatureInfo.world_h(1, h_idx) == obj.CornerIndex(1, 1) &&...
            FullResObj.LineFeatureInfo.world_h(2, h_idx) == obj.CornerIndex(1, 2)
        k_h_left = k_h_left+1;
        lineStack_h_left(:,k_h_left) = FullResObj.LineFeatureInfo.line_h(:,h_idx);
        centerStack_h_left(:,k_h_left) = FullResObj.LineFeatureInfo.center_h(:,h_idx);
        MaxNCC_h_left(1,k_h_left) = FullResObj.LineFeatureInfo.zspMaxNcc_h(1,h_idx);
    end
    if FullResObj.LineFeatureInfo.world_h(1, h_idx) == obj.CornerIndex(1, 1)+1 &&...
            FullResObj.LineFeatureInfo.world_h(2, h_idx) == obj.CornerIndex(1, 2)
        k_h_right = k_h_right+1;
        lineStack_h_right(:,k_h_right) = FullResObj.LineFeatureInfo.line_h(:,h_idx);
        centerStack_h_right(:,k_h_right) = FullResObj.LineFeatureInfo.center_h(:,h_idx);
        MaxNCC_h_right(1,k_h_right) = FullResObj.LineFeatureInfo.zspMaxNcc_h(1,h_idx);
    end
end
for v_idx = 1:size(FullResObj.LineFeatureInfo.world_v, 2)
    if FullResObj.LineFeatureInfo.world_v(1, v_idx) == obj.CornerIndex(1, 1) &&...
            FullResObj.LineFeatureInfo.world_v(2, v_idx) == obj.CornerIndex(1, 2)+1
        k_v_down = k_v_down+1;
        lineStack_v_down(:,k_v_down) = FullResObj.LineFeatureInfo.line_v(:,v_idx);
        centerStack_v_down(:,k_v_down) = FullResObj.LineFeatureInfo.center_v(:,v_idx);
        MaxNCC_v_down(1,k_v_down) = FullResObj.LineFeatureInfo.zspMaxNcc_v(1,v_idx);
    end
    if FullResObj.LineFeatureInfo.world_v(1, v_idx) == obj.CornerIndex(1, 1) &&...
            FullResObj.LineFeatureInfo.world_v(2, v_idx) == obj.CornerIndex(1, 2)
        k_v_up = k_v_up+1;
        lineStack_v_up(:,k_v_up) = FullResObj.LineFeatureInfo.line_v(:,v_idx);
        centerStack_v_up(:,k_v_up) = FullResObj.LineFeatureInfo.center_v(:,v_idx);
        MaxNCC_v_up(1,k_v_up) = FullResObj.LineFeatureInfo.zspMaxNcc_v(1,v_idx);
    end
end

%-------------------
if k_h_left
    obj.HLine.original.lineStack_left = lineStack_h_left(:,1:k_h_left);
    obj.HLine.original.centerStack_left = centerStack_h_left(:,1:k_h_left);
    obj.HLine.original.k_num_left = k_h_left;
    obj.HNCCGroup_left = MaxNCC_h_left(1,1:k_h_left);
end

if k_h_right
    obj.HLine.original.lineStack_right = lineStack_h_right(:,1:k_h_right);
    obj.HLine.original.centerStack_right = centerStack_h_right(:,1:k_h_right);
    obj.HLine.original.k_num_right = k_h_right;
    obj.HNCCGroup_right = MaxNCC_h_right(1,1:k_h_right);
end

if k_v_up
    obj.VLine.original.lineStack_up = lineStack_v_up(:,1:k_v_up);
    obj.VLine.original.centerStack_up = centerStack_v_up(:,1:k_v_up);
    obj.VLine.original.k_num_up = k_v_up;
    obj.VNCCGroup_up = MaxNCC_v_up(1,1:k_v_up);
end

if k_v_down
    obj.VLine.original.lineStack_down = lineStack_v_down(:,1:k_v_down);
    obj.VLine.original.centerStack_down = centerStack_v_down(:,1:k_v_down);
    obj.VLine.original.k_num_down = k_v_down;
    obj.VNCCGroup_down = MaxNCC_v_down(1,1:1:k_v_down);
end

%-------------------

%-------------------
end