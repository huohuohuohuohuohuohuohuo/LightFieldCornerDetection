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

%---------JDY 20190405 (1)新坐标系原点计算
center_ref = [0;0;0];
center_ref(1,1) = 0.5*(max(centerStack(1,:)) + min(centerStack(1,:)));
center_ref(2,1) = 0.5*(max(centerStack(2,:)) + min(centerStack(2,:)));
%---------------------

for i=1:k_num
    %%%每个宏像素的linefeature对应的3D空间中，点XYZ，的平面的方程，其中点XYZ的坐标大小，以PixelPitch为单位长度    
    %---------- modified by JDY 20190225
    L_plane(i,1) = lineStack(1,i);
    L_plane(i,2) = lineStack(2,i);
    L_plane(i,3) =  - lineStack(3,i)*(pixelPitch/l_dis);
    L_plane(i,4) = (-1)*((lineStack(1:2,i))')*centerStack(1:2,i); % centerStack_h以像素为单位
    %---------- modified by JDY 20190225
    %---------JDY 20190405 (2)新坐标系中平面方程的系数计算
   
    L_plane(i,4) = L_plane(i,1:3)*center_ref +L_plane(i,4);
    
    %D_ref = (L_plane(i,1)*center_ref(1,1)+L_plane(i,2)*center_ref(2,1)+L_plane(i,3)*0)+L_plane(i,4);
    %L_plane(i,4) = D_ref;
    %---------------------
end

%%% [A,B,C,D]*[X,Y,Z,1] = 0;点在线上，求解系数矩阵行空间的两个极大线性无关组，作为3D line的表达形式
L_3Dline = zeros(2,4);
Point1_On3Dline = zeros(4,1);
Point2_On3Dline = zeros(4,1);

%cond((L_plane);在做svd之前，判断矩阵条件数（判断矩阵是否是病态矩阵）

[U,S,V] = svd(L_plane);

L_3Dline(1,:)=V(:,1)';
L_3Dline(2,:)=V(:,2)';
Point1_On3Dline(:,1)=V(:,3);
Point1_On3Dline=Point1_On3Dline/Point1_On3Dline(end);
Point2_On3Dline(:,1)=V(:,4);
Point2_On3Dline=Point2_On3Dline/Point2_On3Dline(end);

%---------JDY 20190405 (3)新坐标系转原坐标系
% L_3Dline(1,4)= (L_3Dline(1,1)*center_ref(1,1)+L_3Dline(1,2)*center_ref(2,1)+L_3Dline(1,3)*0)+L_3Dline(1,4);
% L_3Dline(2,4)= (L_3Dline(2,1)*center_ref(1,1)+L_3Dline(2,2)*center_ref(2,1)+L_3Dline(2,3)*0)+L_3Dline(2,4);
L_3Dline(1,4) = -L_3Dline(1,1:3)*center_ref +L_3Dline(1,4);
L_3Dline(2,4) = -L_3Dline(2,1:3)*center_ref +L_3Dline(2,4);
Point1_On3Dline(1:3,1) = Point1_On3Dline(1:3,1)+center_ref;
Point2_On3Dline(1:3,1) = Point2_On3Dline(1:3,1)+center_ref;
%---------------------
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
