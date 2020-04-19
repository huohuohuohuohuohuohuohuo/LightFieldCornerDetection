function SelectedSubImgLine2CornerPoint(obj, corner, HV_flag)
if HV_flag == 'h'
    %%selected corner point
    for i = 1:size(corner,2)
        if (corner(1,i) == obj.CornerIndex(1,1)) &&...
                (corner(2,i) == obj.CornerIndex(1,2))
            obj.HSubLine_corners.corner_mid = corner(3:4,i);
        end
        if (corner(1,i) == (obj.CornerIndex(1,1)-1)) &&...
                (corner(2,i) == obj.CornerIndex(1,2))
            obj.HSubLine_corners.corner_left = corner(3:4,i);
        end
        if (corner(1,i) == (obj.CornerIndex(1,1)+1)) &&...
                (corner(2,i) == obj.CornerIndex(1,2))
            obj.HSubLine_corners.corner_right = corner(3:4,i);
        end
    end
end
if HV_flag == 'v'
    %%selected corner point
    for i = 1:size(corner,2)
        if (corner(1,i) == obj.CornerIndex(1,1)) &&...
                (corner(2,i) == obj.CornerIndex(1,2))
            obj.VSubLine_corners.corner_mid = corner(3:4,i);
        end
        if (corner(1,i) == obj.CornerIndex(1,1)) &&...
                (corner(2,i) == (obj.CornerIndex(1,2) - 1))
            obj.VSubLine_corners.corner_up = corner(3:4,i);
        end
        if (corner(1,i) == obj.CornerIndex(1,1)) &&...
                (corner(2,i) == (obj.CornerIndex(1,2) + 1))
            obj.VSubLine_corners.corner_down = corner(3:4,i);
        end
    end
end

end