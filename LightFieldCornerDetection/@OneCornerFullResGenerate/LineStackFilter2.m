function LineStackFilter2(obj,HV_flag)

%%% Paras of line which links left point and right point
if HV_flag == 'h'
    if obj.HSubLine_corners.corner_left(1,1)~=0 && obj.HSubLine_corners.corner_left(2,1)~=0 && ~isempty(obj.HLine.filtered.centerStack_left)
        [Line_SubImg_k_left, ~]= Computerkb(obj.HSubLine_corners.corner_left,obj.HSubLine_corners.corner_mid);
        
        for i = 1:obj.HLine.filtered.k_num_left % ��ǰ������ı�������������Ϊ��λ�İ�
            %%%ɸѡ��ԭʼlinefeather��б��������ӿ׾�ͼ���еĳ�ʼlinefeather��б��Line_SubImg_k���нǴ���5�ȣ��Ͳ�Ҫ�ˡ�
            if abs(obj.HLine.filtered.lineStack_left(1:2,i)'*[Line_SubImg_k_left; -1])...
                    /(norm(obj.HLine.filtered.lineStack_left(1:2,i))*norm([Line_SubImg_k_left; -1]))...
                    <= cos(5*pi/180) % ��8�ȣ�5�ȣ����Ǽ��ȣ�������һ���ֵ�����
                % �����ߵķ��������ļн�(���ڻ�����ģֵ�����нǵ�����)��Ҳ�������ߵķ������ļн�
                obj.HLine.filtered.centerStack_left(1,i) = 0;
            end
        end
        Index = find(obj.HLine.filtered.centerStack_left(1,:) == 0);
        obj.HLine.filtered.lineStack_left(:,Index) = [];
        obj.HLine.filtered.centerStack_left(:,Index) = [];
        obj.HNCCGroup_left(:,Index) = [];
        obj.HLine.filtered.k_num_left = size(obj.HLine.filtered.lineStack_left, 2);
    end
    
    if obj.HSubLine_corners.corner_right(1,1)~=0 && obj.HSubLine_corners.corner_right(2,1)~=0 && ~isempty(obj.HLine.filtered.centerStack_right)
        [Line_SubImg_k_right, ~]= Computerkb(obj.HSubLine_corners.corner_right,obj.HSubLine_corners.corner_mid);
        
        for i = 1:obj.HLine.filtered.k_num_right % ��ǰ������ı�������������Ϊ��λ�İ�
            %%%ɸѡ��ԭʼlinefeather��б��������ӿ׾�ͼ���еĳ�ʼlinefeather��б��Line_SubImg_k���нǴ���5�ȣ��Ͳ�Ҫ�ˡ�
            if abs(obj.HLine.filtered.lineStack_right(1:2,i)'*[Line_SubImg_k_right; -1])...
                    /(norm(obj.HLine.filtered.lineStack_right(1:2,i))*norm([Line_SubImg_k_right; -1]))...
                    <= cos(5*pi/180) % ��8�ȣ�5�ȣ����Ǽ��ȣ�������һ���ֵ�����
                % �����ߵķ��������ļн�(���ڻ�����ģֵ�����нǵ�����)��Ҳ�������ߵķ������ļн�
                obj.HLine.filtered.centerStack_right(1,i) = 0;
            end
        end
        
        Index = find(obj.HLine.filtered.centerStack_right(1,:) == 0);
        obj.HLine.filtered.lineStack_right(:,Index) = [];
        obj.HLine.filtered.centerStack_right(:,Index) = [];
        obj.HNCCGroup_right(:,Index) = [];
        obj.HLine.filtered.k_num_right = size(obj.HLine.filtered.lineStack_right, 2);
    end
    
elseif HV_flag == 'v'
    if obj.VSubLine_corners.corner_up(1,1)~=0 && obj.VSubLine_corners.corner_up(2,1)~=0
        [Line_SubImg_k_up, ~]= Computerkb(obj.VSubLine_corners.corner_up,obj.VSubLine_corners.corner_mid);
        for i = 1:obj.VLine.filtered.k_num_up % ��ǰ������ı�������������Ϊ��λ�İ�
            %%%ɸѡ��ԭʼlinefeather��б��������ӿ׾�ͼ���еĳ�ʼlinefeather��б��Line_SubImg_k���нǴ���5�ȣ��Ͳ�Ҫ�ˡ�
            if abs(obj.VLine.filtered.lineStack_up(1:2,i)'*[Line_SubImg_k_up; -1])...
                    /(norm(obj.VLine.filtered.lineStack_up(1:2,i))*norm([Line_SubImg_k_up; -1]))...
                    <= cos(5*pi/180) % ��8�ȣ�5�ȣ����Ǽ��ȣ�������һ���ֵ�����
                % �����ߵķ��������ļн�(���ڻ�����ģֵ�����нǵ�����)��Ҳ�������ߵķ������ļн�
                obj.VLine.filtered.centerStack_up(1,i) = 0;
            end
        end
        Index = find(obj.VLine.filtered.centerStack_up(1,:) == 0);
        obj.VLine.filtered.lineStack_up(:,Index) = [];
        obj.VLine.filtered.centerStack_up(:,Index) = [];
        obj.VNCCGroup_up(:,Index) = [];
        obj.VLine.filtered.k_num_up = size(obj.VLine.filtered.lineStack_up, 2);                  
    end
    if obj.VSubLine_corners.corner_down(1,1)~=0 && obj.VSubLine_corners.corner_down(2,1)~=0
        [Line_SubImg_k_down, ~] = Computerkb(obj.VSubLine_corners.corner_down,obj.HSubLine_corners.corner_mid);
        for i = 1:obj.VLine.filtered.k_num_down % ��ǰ������ı�������������Ϊ��λ�İ�
            %%%ɸѡ��ԭʼlinefeather��б��������ӿ׾�ͼ���еĳ�ʼlinefeather��б��Line_SubImg_k���нǴ���5�ȣ��Ͳ�Ҫ�ˡ�
            if abs(obj.VLine.filtered.lineStack_down(1:2,i)'*[Line_SubImg_k_down; -1])...
                    /(norm(obj.VLine.filtered.lineStack_down(1:2,i))*norm([Line_SubImg_k_down; -1]))...
                    <= cos(5*pi/180) % ��8�ȣ�5�ȣ����Ǽ��ȣ�������һ���ֵ�����
                % �����ߵķ��������ļн�(���ڻ�����ģֵ�����нǵ�����)��Ҳ�������ߵķ������ļн�
                obj.VLine.filtered.centerStack_down(1,i) = 0;
            end
        end
        Index = find(obj.VLine.filtered.centerStack_down(1,:) == 0);
        obj.VLine.filtered.lineStack_down(:,Index) = [];
        obj.VLine.filtered.centerStack_down(:,Index) = [];
        obj.VNCCGroup_down(:,Index) = [];
        obj.VLine.filtered.k_num_down = size(obj.VLine.filtered.lineStack_down, 2);        
    end
end

end

function [Line_SubImg_k, Line_SubImg_b] = Computerkb(corner1,corner2)
Line_SubImg_k = (corner2(2,1) - corner1(2,1)) /...
    (corner2(1,1) - corner1(1,1));
Line_SubImg_b = -Line_SubImg_k*corner1(1,1)+corner1(2,1);
end