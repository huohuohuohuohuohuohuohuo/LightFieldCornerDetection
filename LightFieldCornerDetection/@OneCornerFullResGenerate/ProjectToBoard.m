%将raw上的角点投影到标定板上（含去畸变）
function ProjectToBoard(obj, StartTotal, CornerPoint3D,loop,CaliUnit)
load('F:\ZSP\OurDataSet-proposed\OurDataSet2-UniformMicrolensCenterWrongDeltaZ----pick\HMatrixOurDataSet2.mat');
load('F:\ZSP\OurDataSet-proposed\OurDataSet2-UniformMicrolensCenterWrongDeltaZ----pick\cameraParamsOurDataSet2.mat');
% load('D:\LightField\light-field-TB-master\Sample_test\Images\biaoding0512\3\PNG\HMatrix\HMatrix.mat');
% load('D:\LightField\light-field-TB-master\Sample_test\Images\biaoding0512\3\PNG\cameraCalibrator\cameraParams_OurProposed_Dataset3.mat');

% hold on;
% color = 'g*';
% plot(CornerPoint3D(1),CornerPoint3D(2),color);


Xs_stack = zeros(2,3000);
XsCenter_stack = zeros(2,3000);
k_xs_num = 0;
center_list = StartTotal.center_list.center_list;

for i = 1:length(center_list)
    if norm(center_list(:,i) - CornerPoint3D(1:2,1)) < 20 * StartTotal.sensor.d_img
        xHat_coeff = -obj.l_dis / obj.pixelPitch / CornerPoint3D(3,1);
        xCenter_coeff = 1 + obj.l_dis / obj.pixelPitch / CornerPoint3D(3,1);
        xs = xHat_coeff*CornerPoint3D(1:2,1)+xCenter_coeff*center_list(:,i);
        if ((xs - center_list(:,i))'*(xs - center_list(:,i))) <= (obj.radius * obj.radius)
            k_xs_num = k_xs_num + 1;
            Xs_stack(:,k_xs_num) = xs;
            XsCenter_stack(:,k_xs_num) = center_list(:,i);
        end
    end
end

Xs_stack = zeros(2,3000);
XsCenter_stack = zeros(2,3000);
k_xs_num = 0;
center_list = StartTotal.center_list.center_list;
% index1=obj.CornerIndex(1);
% index2=obj.CornerIndex(2);
% 
% save(['D:\LightField\light-field-TB-master\Sample_test\Images\biaoding0512\2\PNG\XsStack\XsStack',num2str(loop),'_',num2str(index1),'_',num2str(index2),'.mat'],'Xs_stack');
[undistortedPoints,~] = undistortPoints( [CornerPoint3D(1),CornerPoint3D(2)],cameraParams);
UndisCornerPoint3D=[undistortedPoints';CornerPoint3D(3);1];
%再调用Examination？
% obj.Examination(StartTotal,UndisCornerPoint3D,loop);
for i = 1:length(center_list)
    if norm(center_list(:,i) - UndisCornerPoint3D(1:2,1)) < 20 * StartTotal.sensor.d_img
        xHat_coeff = -obj.l_dis / obj.pixelPitch / UndisCornerPoint3D(3,1);
        xCenter_coeff = 1 + obj.l_dis / obj.pixelPitch / UndisCornerPoint3D(3,1);
        xs = xHat_coeff*UndisCornerPoint3D(1:2,1)+xCenter_coeff*center_list(:,i);
        if ((xs - center_list(:,i))'*(xs - center_list(:,i))) <= (obj.radius * obj.radius)
            k_xs_num = k_xs_num + 1;
            Xs_stack(:,k_xs_num) = xs;
            XsCenter_stack(:,k_xs_num) = center_list(:,i);
        end
    end
end


R=cameraParams.RotationMatrices(:,:,loop)';
T=cameraParams.TranslationVectors(loop,:)';

ijkl1=[Xs_stack-XsCenter_stack;XsCenter_stack;ones(1,length(Xs_stack))];
index=ijkl1(1,:)==0;
ijkl1(:,index)=[];
%再用H算stuv
stuv=HMatrix*ijkl1;

CameraPoint1=[stuv(1,:);stuv(2,:);zeros(1,length(ijkl1))];
CameraPoint2=[stuv(1,:)+stuv(3,:);stuv(2,:)+stuv(4,:);ones(1,length(ijkl1))];

%相机坐标系下两点转换到世界坐标系下
WorldPoint1=R\(CameraPoint1-T);
WorldPoint2=R\(CameraPoint2-T);
% WorldPoint1=R*CameraPoint1+T;
% WorldPoint2=R*CameraPoint2+T;

%为光线与标定板（z=0）的交点
% x_loc=(-WorldPoint1(3,:)./(WorldPoint1(3,:)-WorldPoint2(3,:))).*(WorldPoint1(1,:)-WorldPoint2(1,:))+WorldPoint1(1,:);
% y_loc=(-WorldPoint1(3,:)./(WorldPoint1(3,:)-WorldPoint2(3,:))).*(WorldPoint1(2,:)-WorldPoint2(2,:))+WorldPoint1(2,:);
x_loc=(-WorldPoint1(3,:)./(WorldPoint2(3,:)-WorldPoint1(3,:))).*(WorldPoint2(1,:)-WorldPoint1(1,:))+WorldPoint1(1,:);
y_loc=(-WorldPoint1(3,:)./(WorldPoint2(3,:)-WorldPoint1(3,:))).*(WorldPoint2(2,:)-WorldPoint1(2,:))+WorldPoint1(2,:);
% figure;
plot(x_loc,y_loc,'r.');
hold on;
% boardSize = [StartTotal.CaliInfo.CornerWNum+1,StartTotal.CaliInfo.CornerHNum+1];
% squareSize = CaliUnit;
% % % Generate the world coordinates of the checkerboard corners in the
% % % pattern-centric coordinate system, with the upper-left corner at (0,0).
% worldPoints = generateCheckerboardPoints(boardSize, squareSize);
% %世界坐标系的点转换到相机坐标系下
% 
% cameraPoints =R*worldPoints+T;

% plot(Xs_stack(1,1:k_xs_num),Xs_stack(2,1:k_xs_num),'m.','MarkerSize',5);
% plot(XsCenter_stack(1,1:k_xs_num),XsCenter_stack(2,1:k_xs_num),'y.','MarkerSize',5);
end