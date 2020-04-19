function [CornerPoint3D]=P1234intersec(obj,flag)
if flag == 1
    P1=obj.H3DPoints.refine.Point1;
    P2=obj.H3DPoints.refine.Point2;
    P3=obj.V3DPoints.refine.Point1;
    P4=obj.V3DPoints.refine.Point2;
else
    P1=obj.H3DPoints.initial.Point1;
    P2=obj.H3DPoints.initial.Point2;
    P3=obj.V3DPoints.initial.Point1;
    P4=obj.V3DPoints.initial.Point2;
end
A=[P1-P2,P4-P3];
b=[P3-P1];
T=pinv(A)*b;
CornerPoint3D=P1+T(1)*[P1-P2];


% [~,~,VSpace1]=svd([P1';P2']);
% L3DLine1=VSpace1(:,3:4);
% [~,~,VSpace2]=svd([P3';P4']);
% L3DLine2=VSpace2(:,3:4);
% Planes=[L3DLine1';L3DLine2'];
% [~,~,V]=svd(Planes);
% CornerPoint3D=V(:,end);