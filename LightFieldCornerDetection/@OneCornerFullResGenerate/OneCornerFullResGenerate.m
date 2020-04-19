classdef OneCornerFullResGenerate < handle
properties
    CornerIndex = [-1, 0] % 默认量，可以在构造函数里修改
    %----------
    l_dis
    pixelPitch
    radius
    MaxNCC_H
    MaxNCC_V
    %LineGroup = struct('lineStack',[],'centerStack',[],'k_num',0)
    %Line3DPoints =  struct('Point1',[0;0;0;0],'Point2',[0;0;0;0])
    
    %-----------------------
    HLine = struct('original',struct('lineStack_left',[],'centerStack_left',[],...
        'k_num_left',0,'lineStack_right',[],'centerStack_right',[],'k_num_right',0),...
        'filtered',struct('lineStack_left',[],'centerStack_left',[],'k_num_left',0,...
           'lineStack_right',[],'centerStack_right',[],'k_num_right',0),...
        'initial',struct('lineStack_left',[],'centerStack_left',[],'k_num_left',0,...
            'lineStack_right',[],'centerStack_right',[],'k_num_right',0),...
        'refine',struct('lineStack_left',[],'centerStack_left',[],'k_num_left',0,...
            'lineStack_right',[],'centerStack_right',[],'k_num_right',0))
    HNCCGroup_left
    HNCCGroup_right
    HLine_SubImg = struct('Point1',[0;0;0;0],'Point2',[0;0;0;0])
    H3DPoints = struct('initial',struct('Point1',[0;0;0;0],'Point2',[0;0;0;0]),...       
        'refine',struct('Point1',[0;0;0;0],'Point2',[0;0;0;0]))  
    HSubLine_corners = struct('corner_mid',[0.0;0.0],'corner_left',[0.0;0.0],'corner_right',[0.0;0.0]); %SubImgLine2CornerPoint
    HPlanes = struct('initial',[0,0,0,0;0,0,0,0],...        
        'refine',[0,0,0,0;0,0,0,0])
    %------------------------
    VLine = struct('original',struct('lineStack_up',[],'centerStack_up',[],'k_num_up',0,...
           'lineStack_down',[],'centerStack_down',[],'k_num_down',0),...       
        'filtered',struct('lineStack_up',[],'centerStack_up',[],'k_num_up',0,...
           'lineStack_down',[],'centerStack_down',[],'k_num_down',0),...
        'initial',struct('lineStack_up',[],'centerStack_up',[],'k_num_up',0,...
            'lineStack_down',[],'centerStack_down',[],'k_num_down',0),...
        'refine',struct('lineStack_up',[],'centerStack_up',[],'k_num_up',0,...
            'lineStack_down',[],'centerStack_down',[],'k_num_down',0))
    VNCCGroup_up  
    VNCCGroup_down
    VLine_SubImg = struct('Point1',[0;0;0;0],'Point2',[0;0;0;0])
    V3DPoints = struct('initial',struct('Point1',[0;0;0;0],'Point2',[0;0;0;0]),...        
        'refine',struct('Point1',[0;0;0;0],'Point2',[0;0;0;0]))
    VSubLine_corners = struct('corner_mid',[0.0;0.0],'corner_up',[0.0;0.0],'corner_down',[0.0;0.0]); %SubImgLine2CornerPoint
    VPlanes = struct('initial',[0,0,0,0;0,0,0,0],...       
        'refine',[0,0,0,0;0,0,0,0])
end
methods
    function obj = OneCornerFullResGenerate(Index, FullResObj)
        if nargin == 1
            obj.CornerIndex = Index;
        elseif nargin == 0
            obj.CornerIndex = [-1, 0]; % 默认量，可以在构造函数里修改
        elseif nargin == 2
            obj.CornerIndex = Index; 
            obj.pixelPitch = FullResObj.sensor.pixelPitch;
            obj.l_dis = FullResObj.mla.l_dis;
            obj.radius = FullResObj.mla.radius;
        else
            error('wrong input arguments');
        end
    end
    SelectedCorner(obj, FullResObj); 
    SelectedSubImgLine2CornerPoint(obj, corner, HV_flag);
    %LineFeatherEstablished_h(obj, FullResObj);
    %LineFeatherEstablished_v(obj, FullResObj);
    %--------------------------------
    LineStackFilter1(obj, HV_flag);
    LineStackFilter2(obj, HV_flag);
    LineStackFilter3(obj,HV_flag);
    Calculate3Dline(obj, HV_flag);
    OutputLineGroup = Reprojection3Dto2D(obj, InputLineGroup, Input3DPoints, HVFlag);
    ExportLine3DLocalTerminals(obj, Point1_On3Dline, Point2_On3Dline, d_img, HVflag);
    IteratedRefine3DLine_h(obj, StartTotal);
    IteratedRefine3DLine_v(obj, StartTotal);
    CornerPoint3D = P1234intersec(obj,flag);
    NCC = TotalNCC( obj,OutputLineGroup,XGrid_coords,YGrid_coords,XGrid_integer,YGrid_integer, source, HVFlag);
    Examination(obj, StartTotal, CornerPoint3D,loop)
    SelectHalfLineMicroLens(obj,d_img)
    %--------------------------------
    Plot_LineFeature(obj, LineGroup, HVflag, color);
    %--------- jdy 20190426
    [DeltaZ] = generateDeltaZ(obj, StartTotal, HV_flag);
    %----------hx 20190716-----------
    %将raw上角点投到标定板上的画图函数，正式程序中不应该含有该函数
    ProjectToBoard(obj,StartTotal,CornerPoint3D,loop,CaliUnit);
end
end