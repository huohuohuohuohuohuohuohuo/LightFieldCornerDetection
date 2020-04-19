function LineStackFilter3(obj,HV_flag)

NccTheshold = 0.85;

if HV_flag == 'h'
    if ~isempty(obj.HNCCGroup_left)
        Index = find (obj.HNCCGroup_left < NccTheshold);
        obj.HNCCGroup_left(:,Index) = [];
        obj.HLine.filtered.lineStack_left(:,Index) = [];
        obj.HLine.filtered.centerStack_left(:,Index) = [];
        obj.HLine.filtered.k_num_left = size(obj.HLine.filtered.lineStack_left, 2);
    end
    if ~isempty(obj.HNCCGroup_right)
        Index = find (obj.HNCCGroup_right < NccTheshold);
        obj.HNCCGroup_right(:,Index) = [];
        obj.HLine.filtered.lineStack_right(:,Index) = [];
        obj.HLine.filtered.centerStack_right(:,Index) = [];
        obj.HLine.filtered.k_num_right = size(obj.HLine.filtered.lineStack_right, 2);
    end
end

if HV_flag == 'v'
    if ~isempty(obj.VNCCGroup_up)
        Index = find (obj.VNCCGroup_up < NccTheshold);
        obj.VNCCGroup_up(:,Index) = [];
        obj.VLine.filtered.lineStack_up(:,Index) = [];
        obj.VLine.filtered.centerStack_up(:,Index) = [];
        obj.VLine.filtered.k_num_up = size(obj.VLine.filtered.lineStack_up, 2);
    end
    if ~isempty(obj.VNCCGroup_down)
        Index = find (obj.VNCCGroup_down < NccTheshold);
        obj.VNCCGroup_down(:,Index) = [];
        obj.VLine.filtered.lineStack_down(:,Index) = [];
        obj.VLine.filtered.centerStack_down(:,Index) = [];
        obj.VLine.filtered.k_num_down = size(obj.VLine.filtered.lineStack_down, 2);
    end
end

end