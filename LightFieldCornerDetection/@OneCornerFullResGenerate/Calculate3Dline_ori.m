function Calculate3Dline(obj,HV_flag)
%%%% 预备。。。JDY 20190309
l_dis = obj.l_dis;
pixelPitch = obj.pixelPitch;
%-------------------
if HV_flag == 'h'
    lineStack = [obj.HLine.filtered.lineStack_left,obj.HLine.filtered.lineStack_right];
    centerStack = [obj.HLine.filtered.centerStack_left,obj.HLine.filtered.centerStack_right];
    k_num = obj.HLine.filtered.k_num_left + obj.HLine.filtered.k_num_right;
elseif HV_flag == 'v'
    lineStack = [obj.VLine.filtered.lineStack_up,obj.VLine.filtered.lineStack_down];
    centerStack = [obj.VLine.filtered.centerStack_up,obj.VLine.filtered.centerStack_down];
    k_num = obj.VLine.filtered.k_num_up + obj.VLine.filtered.k_num_down;
end
%%%%%%%%%%%%%% calculate the 3D line in camera image space
L_plane = zeros(k_num,4);% 平面方程 L = [A;B;C;D];

%temp =  1;
for i=1:k_num
%     Zb = -1*((-1)*((lineStack(1:2,i))')*centerStack(1:2,i))/(- lineStack(3,i)*(pixelPitch/l_dis));
%     if Zb>5000
%         continue;
%     end
    %%%每个宏像素的linefeature对应的3D空间中，点XYZ，的平面的方程，其中点XYZ的坐标大小，以PixelPitch为单位长度
%    ---------- modified by JDY 20190225
        L_plane(i,1) = lineStack(1,i);
        L_plane(i,2) = lineStack(2,i);
        L_plane(i,3) =  - lineStack(3,i)*(pixelPitch/l_dis);
        L_plane(i,4) = (-1)*((lineStack(1:2,i))')*centerStack(1:2,i); % centerStack_h以像素为单位
%     L_plane(temp,1) = lineStack(1,i);
%     L_plane(temp,2) = lineStack(2,i);
%     L_plane(temp,3) =  - lineStack(3,i)*(pixelPitch/l_dis);
%     L_plane(temp,4) = (-1)*((lineStack(1:2,i))')*centerStack(1:2,i); % centerStack_h以像素为单位
%     temp = temp + 1;
    %---------- modified by JDY 20190225
    
end
%%% [A,B,C,D]*[X,Y,Z,1] = 0;点在线上，求解系数矩阵行空间的两个极大线性无关组，作为3D line的表达形式
L_3Dline = zeros(2,4);
Point1_On3Dline = zeros(4,1);
Point2_On3Dline = zeros(4,1);

%L_plane(temp:end,:) = [];

[U,S,V] = svd(L_plane);
L_3Dline(1,:)=V(:,1)';
L_3Dline(2,:)=V(:,2)';
Point1_On3Dline(:,1)=V(:,3);
Point1_On3Dline=Point1_On3Dline/Point1_On3Dline(end);
Point2_On3Dline(:,1)=V(:,4);
Point2_On3Dline=Point2_On3Dline/Point2_On3Dline(end);

if HV_flag == 'h'
    obj.H3DPoints.initial.Point1 = Point1_On3Dline;
    obj.H3DPoints.initial.Point2 = Point2_On3Dline;
    obj.HPlanes.filtered = L_3Dline;
elseif HV_flag == 'v'
    obj.V3DPoints.initial.Point1 = Point1_On3Dline;
    obj.V3DPoints.initial.Point2 = Point2_On3Dline;
    obj.VPlanes.filtered = L_3Dline;
end
end
