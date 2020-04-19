function [cornerUL, cornerUR, cornerDL, cornerDR] = export4corners(obj)
corners = obj.CornerInfo.corner;
CornerWNum = obj.CaliInfo.CornerWNum;
CornerHNum = obj.CaliInfo.CornerHNum;

minXIdx = 1000;
maxXIdx = -1000;
minYIdx = 1000;
maxYIdx = -1000;
%figure;imshow(obj.CenterSubImg);hold on;
for Idx = 1:size(corners, 2)
    if corners(1, Idx) < minXIdx
        minXIdx = corners(1, Idx);
    end
    if corners(1, Idx) > maxXIdx
        maxXIdx = corners(1, Idx);
    end  
    if corners(2, Idx) < minYIdx
        minYIdx = corners(2, Idx);
    end  
    if corners(2, Idx) > maxYIdx
        maxYIdx = corners(2, Idx);
    end 
    %plot(corners(3,Idx),corners(4,Idx),'g*');
end
for Idx = 1:size(corners, 2)
        if (corners(1, Idx) == (minXIdx+1)) && (corners(2, Idx) == (minYIdx+1))
            cornerUL = corners(3:4, Idx);
        end
        if (corners(1, Idx) == (maxXIdx-1)) && (corners(2, Idx) == (minYIdx+1))
            cornerUR = corners(3:4, Idx);
        end
        if (corners(1, Idx) == (maxXIdx-1)) && (corners(2, Idx) == (maxYIdx-1))
            cornerDR = corners(3:4, Idx);
        end
        if (corners(1, Idx) == (minXIdx+1)) && (corners(2, Idx) == (maxYIdx-1))
            cornerDL = corners(3:4, Idx);
        end
end
obj.Corner4.cornerUL(1:2,1) = cornerUL;
obj.Corner4.cornerUR(1:2,1) = cornerUR;
obj.Corner4.cornerDR(1:2,1) = cornerDR;
obj.Corner4.cornerDL(1:2,1) = cornerDL;

% figure;imshow(obj.CenterSubImg);hold on;
% plot(cornerUL(1,1),cornerUL(2,1),'g*');
% plot(cornerUR(1,1),cornerUR(2,1),'g*');
% plot(cornerDR(1,1),cornerDR(2,1),'g*');
% plot(cornerDL(1,1),cornerDL(2,1),'g*');