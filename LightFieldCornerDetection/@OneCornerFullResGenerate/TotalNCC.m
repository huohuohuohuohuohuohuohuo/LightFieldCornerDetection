function NCC = TotalNCC( obj,OutputLineGroup,XGrid_coords,YGrid_coords,XGrid_integer,YGrid_integer, source, HVFlag)
radius = obj.radius;

if HVFlag == 'h'
    lineStack_output = [OutputLineGroup.lineStack_left, OutputLineGroup.lineStack_right];
    k_num = OutputLineGroup.k_num_left + OutputLineGroup.k_num_right;
end

if HVFlag == 'v'
    lineStack_output = [OutputLineGroup.lineStack_up, OutputLineGroup.lineStack_down];
    k_num = OutputLineGroup.k_num_up + OutputLineGroup.k_num_down;
end

method1 = 4;

if method1 == 4
    %for lytro
    if radius==5
    load('LinearTemplate5_11.mat', 'TemplateWeight');
    end
    %for illum
    if radius==7
    load('LinearTemplate7_15.mat', 'TemplateWeight');
    end
end
line_param = zeros(3,k_num);
line_param(1:2,:) = lineStack_output(1:2,:);
line_param(3,:) = lineStack_output(3,:)...
    - (XGrid_coords - XGrid_integer).*lineStack_output(1,:)...
    - (YGrid_coords - YGrid_integer).*lineStack_output(2,:);% 把line的参数变到以，新的整数格点为原点的坐标系上'

%实时生成模板
template = LinearTemplate(radius,line_param); % 该函数会产生2*（radius+1）+1边长大小的正方形，应该够了吧
%hx 0628
%save('template_example.mat','template');
% imshow(template);


if HVFlag == 'h'
    template(:,1:OutputLineGroup.k_num_left*(2*radius+1)) = 1 - template(:,1:OutputLineGroup.k_num_left*(2*radius+1));
end
if HVFlag == 'v'
    template(:,1:OutputLineGroup.k_num_up*(2*radius+1)) = 1 - template(:,1:OutputLineGroup.k_num_up*(2*radius+1));
end
if method1 == 1
    NCC1 = 0;
    NCC2 = 0;
    template2 = 1-template;
    
    SumCross1 = sum(sum(source.*template));
    SumSource1 = sum(sum(source.*source));
    SumTemplate1 = sum(sum(template.*template));
    
    SumCross2 = sum(sum(source.*template2));
    SumSource2 = sum(sum(source.*source));
    SumTemplate2 =sum(sum(template2.*template2));
    Num1 = SumSource1 * SumTemplate1;
    Num2 = SumSource2 * SumTemplate2;
    
    if Num1 > 0
        NCC1 = SumCross1/sqrt(Num1);
    end
    if Num2 > 0
        NCC2 = SumCross2/sqrt(Num2);
    end
    if NCC1 > NCC2
        NCC = NCC1;
    else
        NCC = NCC2;
    end
end
if method1 == 2
    NCC = 0;
    t1 = source(:)-mean(source(:));
    t2 = template(:)-mean(template(:));
    w = TemplateWeight(:)/sum(TemplateWeight(:));
    if t2~=0
        NCC=abs(sum(t1.*t2.*w)/sqrt(sum(t1.*t1.*w)*sum(t2.*t2.*w)));
    end
end
if method1 == 3

    MyNcc1 = 1;
    MyNcc2 = 1;
    
    template2 = 1-template;
     
    MySize = 2*radius+1;
    for num = 1 : size(template,2)/MySize
        MyTemp1 = template(:,1+(num-1)*MySize:num*MySize);
        MyTemp2 = template2(:,1+(num-1)*MySize:num*MySize);
        MySour =  source(:,1+(num-1)*MySize:num*MySize);
        
        MyPro1 = sum(sum(MySour .* MyTemp1));
        MyPro2 = sum(sum(MySour .* MyTemp2));
        
        MySourPro = sum(sum(MySour .* MySour));
        MyTempPro1 = sum(sum(MyTemp1 .* MyTemp1));
        MyTempPro2 = sum(sum(MyTemp2 .* MyTemp2));
        if MyTempPro1>0
            MyNcc1 = MyNcc1 * (MyPro1/sqrt(MySourPro*MyTempPro1));
        end
        if MyTempPro2>0
            MyNcc2 = MyNcc2 * (MyPro2/sqrt(MySourPro*MyTempPro2));
        end
    end
    if MyNcc1 > MyNcc2
        NCC = MyNcc1;
    else
        NCC = MyNcc2;
    end
end
if method1 == 4
    MySize = size(template,1);
    MyNcc1 = zeros(1,size(template,2)/MySize);
    
    for num = 1 : size(template,2)/MySize
        MyTemp1 = template(:,1+(num-1)*MySize:num*MySize);       
        MySour =  source(:,1+(num-1)*MySize:num*MySize);        
        
        t1 = MyTemp1(:)-mean(MyTemp1(:));
        t2 = MySour(:)-mean(MySour(:));        
        w = TemplateWeight(:)/sum(TemplateWeight(:));
       
        if t1~=0
            MyNcc1(1,num) = abs(sum(t1.*t2.*w)/sqrt(sum(t1.*t1.*w)*sum(t2.*t2.*w)));
        end
    end
    NCC = sum(MyNcc1);
end

end

function template=LinearTemplate(size_half,line_param)

size1=size_half*2+1;
template=zeros(size1,size1*size(line_param,2));
[I,J]=meshgrid(-size_half-0.5:size_half+0.5,-size_half-0.5:size_half+0.5);
I = repmat(I,1,size(line_param,2));
J = repmat(J,1,size(line_param,2));

line_param_1 = repelem(line_param(1,:),size(I,1),size(I,1));
line_param_2 = repelem(line_param(2,:),size(I,1),size(I,1));
line_param_3 = repelem(line_param(3,:),size(I,1),size(I,1));

d=line_param_1(:,:).*I(:,:)+line_param_2(:,:).*J(:,:)+line_param_3(:,:);
d(d<0)=-1;
d(d>=0)=1;

tr = (-size_half-0.5:size_half+0.5);
line_param_11 = repelem(line_param(1,:),1,size(tr,2));
line_param_22 = repelem(line_param(2,:),1,size(tr,2));
line_param_33 = repelem(line_param(3,:),1,size(tr,2));

trg = repmat(tr,1,size(line_param,2));

intersection_x=(-line_param_22(:,:).*trg - line_param_33(:,:))./line_param_11(:,:);
intersection_y=(-line_param_11(:,:).*trg - line_param_33(:,:))./line_param_22(:,:);

z = size(I,1);

for j=1:size1
    for i=1:size(d,2)
        if(mod(i,size1+1) == 0)
            continue;
        end
        tempnum = floor(i/z)*z;
        sum=d(j,i)+d(j,i+1)+d(j+1,i)+d(j+1,i+1);
        if sum==4
            template(j,i)=1;
        elseif sum==-4
            template(j,i)=0;
        elseif abs(sum)==2
            if d(j,i)*sum<0
                temp=abs(intersection_x(tempnum+j)+size_half+1.5-mod(i,z))*abs(intersection_y(i)+size_half+1.5-j)*0.5;
            elseif d(j,i+1)*sum<0
                temp=(1-abs(intersection_x(tempnum+j)+size_half+1.5-mod(i,z)))*abs(intersection_y(i+1)+size_half+1.5-j)*0.5;
            elseif d(j+1,i)*sum<0
                temp=abs(intersection_x(tempnum+j+1)+size_half+1.5-mod(i,z))*(1-abs(intersection_y(i)+size_half+1.5-j))*0.5;
            else
                temp=(1-abs(intersection_x(tempnum+j+1)+size_half+1.5-mod(i,z)))*(1-abs(intersection_y(i+1)+size_half+1.5-j))*0.5;
            end
            if sum>0
                template(j,i)=1-temp;
            else
                template(j,i)=temp;
            end
        else
            if d(j,i)+d(j,i+1)==0
                temp=(abs(intersection_x(tempnum+j)+size_half+1.5-mod(i,z))+abs(intersection_x(tempnum+j+1)+size_half+1.5-mod(i,z)))*0.5;
            else
                temp=(abs(intersection_y(i)+size_half+1.5-j)+abs(intersection_y(i+1)+size_half+1.5-j))*0.5;
            end
            if d(j,i)>0
                template(j,i)=temp;
            else
                template(j,i)=1-temp;
            end
        end
    end
end
template(:,size1+1:size1+1:size(template,2)) = [];
end