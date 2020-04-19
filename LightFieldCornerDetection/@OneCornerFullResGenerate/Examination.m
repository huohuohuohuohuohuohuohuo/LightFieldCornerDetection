function Examination(obj, StartTotal, CornerPoint3D,loop)

hold on;
color = 'g*';
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
% index1=obj.CornerIndex(1);
% index2=obj.CornerIndex(2);

plot(Xs_stack(1,1:k_xs_num),Xs_stack(2,1:k_xs_num),'r.','MarkerSize',5);
% plot(XsCenter_stack(1,1:k_xs_num),XsCenter_stack(2,1:k_xs_num),'y.','MarkerSize',5);


end