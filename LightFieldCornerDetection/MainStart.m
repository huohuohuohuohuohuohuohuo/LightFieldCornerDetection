clear;clc;

%Our DataSet 2
CornerCoor = [5.5*1.732,6*1.732,5*1.732,4.5*1.732;
    5*1.732,4.5*1.732,5*1.732,4.5*1.732;
    5*1.732,5.5*1.732,5*1.732,5.5*1.732;
    4.5*1.732,5.5*1.732,4.5*1.732,5*1.732;
    5*1.732,5.5*1.732,4*1.732,4.5*1.732;
    4.5*1.732,5.5*1.732,7,8;
    9,5.5*1.732,4.5*1.732,7;
    4.5*1.732,10,7,9;
    8,6*1.732,8,9;
    8,7,4.5*1.732,7;
    8,7,4.5*1.732,7;
    5*1.732,6*1.732,4.5*1.732,4.5*1.732;
    6*1.732,5.5*1.732,5*1.732,5*1.732];

CornerCoor=CornerCoor*40./1.4;

CenterlistPath = 'E:\外参标定\CreateFullRes\数据集\OurDataSet-proposed\uniform----pick\microlens_center_list.mat';

type='Illum';
for loop = 1:13
    
    CaliImgPath = ['E:\外参标定\CreateFullRes\数据集\OurDataSet-proposed\uniform----pick\IMG',num2str(loop),'.png'];
    CenterSubImgPath = ['E:\外参标定\CreateFullRes\数据集\OurDataSet-proposed\uniform----pick\CI_IMG',num2str(loop),'.bmp'];
    LineFeatherPath = ['E:\外参标定\CreateFullRes\数据集\OurDataSet-proposed\uniform----pick\L_IMG',num2str(loop),'.mat'];
    CornerInfoPath = ['E:\外参标定\CreateFullRes\数据集\OurDataSet-proposed\uniform----pick\CI_IMG',num2str(loop),'.mat'];
        
    SIZE = 7*11;

    
    REFINE = [];
    INITIAL = [];
    
    StartTotal = FullResGenerate(CenterlistPath, CaliImgPath, CenterSubImgPath, LineFeatherPath, CornerInfoPath,type);
    

    StartTotal.CaliInfo.CornerWNum = 7;
    StartTotal.CaliInfo.CornerHNum = 11;

    figure;
    imshow(uint8(StartTotal.CaliImg));
    hold on;
    
    % 手动给四个角点的Z坐标
    StartTotal.export4corners();
    StartTotal.Corner4.cornerUL(3,1) = CornerCoor(loop,1);
    StartTotal.Corner4.cornerUR(3,1) = CornerCoor(loop,2);
    StartTotal.Corner4.cornerDL(3,1) = CornerCoor(loop,3);
    StartTotal.Corner4.cornerDR(3,1) = CornerCoor(loop,4);
    
    %-----------------------
    
    for i = 1 :SIZE
        OneCorner = OneCornerFullResGenerate(StartTotal.CornerInfo.corner(1:4,i)', StartTotal);
        
        OneCorner.SelectedCorner(StartTotal);
        
        if (OneCorner.HLine.original.k_num_left == 0 && OneCorner.HLine.original.k_num_right == 0)...
                || (OneCorner.VLine.original.k_num_up == 0 && OneCorner.VLine.original.k_num_down == 0)
            continue;
        end
        
        OneCorner.SelectedSubImgLine2CornerPoint(StartTotal.CornerInfo.corner,'h');
        OneCorner.SelectedSubImgLine2CornerPoint(StartTotal.CornerInfo.corner,'v');
        
        % OneCorner.SelectHalfLineMicroLens(StartTotal.sensor.d_img);
        
%                        figure;imshow(uint8(StartTotal.CaliImg));
%                         hold on;
%                         color = 'g-';
%                         OneCorner.Plot_LineFeature(OneCorner.HLine.original, 'h', color);
%                         OneCorner.Plot_LineFeature(OneCorner.VLine.original, 'v', color);
        %                 hold off;close;
        %                 disp('Wait');
        
        OneCorner.HLine.filtered = OneCorner.HLine.original;
        OneCorner.VLine.filtered = OneCorner.VLine.original;
        
        %-----------LineStackFilter2----------%
        OneCorner.LineStackFilter2('h');
        OneCorner.LineStackFilter2('v');
        
        %                 figure;imshow(uint8(StartTotal.CaliImg));
        %                 hold on;
        %                 color = 'g-';
        %                 OneCorner.Plot_LineFeature(OneCorner.HLine.filtered, 'h', color);
        %                 OneCorner.Plot_LineFeature(OneCorner.VLine.filtered, 'v', color);
        %                 hold off;close;
        %                 disp('Wait');
        
        %-----------LineStackFilter3----------%
        OneCorner.LineStackFilter3('h');
        OneCorner.LineStackFilter3('v');
        
%                         figure;imshow(uint8(StartTotal.CaliImg));
%                         hold on;
%                         color = 'g-';
%                         OneCorner.Plot_LineFeature(OneCorner.HLine.filtered, 'h', color);
%                         OneCorner.Plot_LineFeature(OneCorner.VLine.filtered, 'v', color);
%                         hold off;close;
%                         disp('Wait');
        
        %     %-----------Calculate 3D line-----------%
        OneCorner.Calculate3Dline('h');
        OneCorner.Calculate3Dline('v');
        
        %
        %     %-----------Change to the two ends of the line (initial points)-----------%
        OneCorner.ExportLine3DLocalTerminals(OneCorner.H3DPoints.initial.Point1,...
            OneCorner.H3DPoints.initial.Point2, StartTotal.sensor.d_img,'h');
        
        OneCorner.ExportLine3DLocalTerminals(OneCorner.V3DPoints.initial.Point1,...
            OneCorner.V3DPoints.initial.Point2, StartTotal.sensor.d_img,'v');
        
        %------------Reprojection3Dto2D (initial points)--------------%
                   OneCorner.HLine.initial = OneCorner.Reprojection3Dto2D(OneCorner.HLine.original, OneCorner.H3DPoints.initial,'h');
                   OneCorner.VLine.initial = OneCorner.Reprojection3Dto2D(OneCorner.VLine.original, OneCorner.V3DPoints.initial,'v');
        
        %           figure;imshow(uint8(StartTotal.CaliImg));
        %           hold on;
        %           color = 'b-';
        %           OneCorner.Plot_LineFeature( OneCorner.HLine.initial, 'h', color);
        %           OneCorner.Plot_LineFeature(OneCorner.VLine.initial, 'v', color);
        %           hold off;close;
        %     disp('Wait');
        
        %-----------Intersection Point in space(initial)-------------%
                           CornerPoint3D = OneCorner.P1234intersec(0);
        
        %-----------------------Examination-------------------------%
                  OneCorner.Examination(StartTotal,CornerPoint3D,loop);
                   INITIAL = [INITIAL, CornerPoint3D];
                
        %-------------IteratedRefine part---------------------%
        
        OneCorner.IteratedRefine3DLine_h(StartTotal);

        OneCorner.IteratedRefine3DLine_v(StartTotal);
        
        %                 hold on;
        %                 plot([OneCorner.H3DPoints.refine.Point1(1,1), OneCorner.H3DPoints.refine.Point2(1,1)],...
        %                     [OneCorner.H3DPoints.refine.Point1(2,1), OneCorner.H3DPoints.refine.Point2(2,1)],'r-','LineWidth',1);
        %                 plot([OneCorner.V3DPoints.refine.Point1(1,1), OneCorner.V3DPoints.refine.Point2(1,1)],...
        %                     [OneCorner.V3DPoints.refine.Point1(2,1), OneCorner.V3DPoints.refine.Point2(2,1)],'r-','LineWidth',1);
        %
        
        
        %-----------Reprojection3Dto2D (refine points)--------------%
                    OneCorner.HLine.refine = OneCorner.Reprojection3Dto2D(OneCorner.HLine.original, OneCorner.H3DPoints.refine,'h');
                    OneCorner.VLine.refine = OneCorner.Reprojection3Dto2D(OneCorner.VLine.original, OneCorner.V3DPoints.refine,'v');
        
        %figure;imshow(uint8(StartTotal.CaliImg));hold on;
        %         hold on;
        %         color = 'g-';
        %         OneCorner.Plot_LineFeature(OneCorner.HLine.refine, 'h', color);
        %         OneCorner.Plot_LineFeature(OneCorner.VLine.refine, 'v', color);
        %    hold off;close;
        %     disp('Wait');
        
        %--------------Intersection Point in space(refine)-------------%
        CornerPoint3D = OneCorner.P1234intersec(1);
        
        %-----------------------Examination-------------------------%
        OneCorner.Examination(StartTotal,CornerPoint3D,loop);
        
         REFINE = [REFINE, CornerPoint3D];
        
    end
    
end








