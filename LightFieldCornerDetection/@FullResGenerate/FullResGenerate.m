classdef FullResGenerate < handle
    properties
        %%% device :: sensor
        sensor
        %illum
%                  sensor = struct('pixelPitch',1.4,...
%                      'pixelWidth',7728, 'pixelHeight',5368, 'bitsPerPixel', 10,...
%                      'd_img',14.1)
        
%         %lytro
%        sensor = struct('pixelPitch',1.4,...
%            'pixelWidth',3280, 'pixelHeight',3280, 'bitsPerPixel', 12,...
%            'd_img',10)
%         
        
        %%% device::mla
        mla
        %illum
%                  mla = struct(...
%                      'mla_rotation',-0.0025808198843151330948,...
%                      'lensPitch',20,...%2.0000000000000001636e-05;
%                      'sensorOffset',[0,0,40],...%[ -4.4266057014465332508e-06, 4.2581391334533687899e-06, 3.6999999999999998114e-05];
%                      'l_dis',40,...
%                      'radius',7)
%         lytro
%        mla = struct(...
%            'mla_rotation',0.0019290975760668516,...
%            'lensPitch',13.89,...%1.389859962463379e-005;
%            'sensorOffset',[0,0,25],...%[ -2.7138671874999998e-006, 5.6601560115814212e-007, 2.5000000000000001e-005];
%            'l_dis',25,...
%            'radius',5)
        
        %%% device::Main lens
        MainLens
        %illum
%                  MainLens = struct(...
%                      'focalLength', 0.011832640061537134935,...
%                      'opticalCenterOffset',[-5.8207762776874005795e-05,-1.9448425518930889666e-05])
        %lytro
%        MainLens = struct(...
%            'focalLength', 0.0064499998092651363,...
%            'opticalCenterOffset',[-5.8207762776874005795e-05,-1.9448425518930889666e-05])
    end
    properties(Dependent)
        Cali = struct('Unit','halfUnit')
      
    end
    properties
        center_list
        CaliImg
        CenterSubImg
        LineFeatureInfo
        CornerInfo
        %--------jdy 20190425
        CaliInfo = struct('CornerWNum','CornerHNum');
        Corner4 = struct('cornerUL',[0;0;0] ,...
            'cornerUR',[0;0;0] ,...
            'cornerDL', [0;0;0] ,...
            'cornerDR',[0;0;0]);
        %--------------
    end
    methods
        function Cali = get.Cali(obj)
            Cali.Unit = round(obj.sensor.pixelWidth*obj.sensor.pixelPitch/16);
            Cali.halfUnit = obj.Cali.Unit*0.5;
        end
        %-------------------------
        %{
        function SelectedSubImgLine2CornerPoint(obj)
        end
        %}
       
        %--------------------------
        function obj = FullResGenerate(CenterlistPath, CaliImgPath, CenterSubImgPath, LineFeatherPath, CornerInfoPath,type)
            if nargin == 6
                %%%%%%%%%%%%%%%%%%%%%%%% input necessary data {{
                %%% centers of the macro images calculated by white images
                obj.center_list = load(CenterlistPath,'center_list');
                %%% calibration images, center view sub-image
                obj.CaliImg = imread(CaliImgPath);
                obj.CenterSubImg = imread(CenterSubImgPath);
                %figure;imshow(CenterSubImg);
                %%% line feather info
                obj.LineFeatureInfo = load(LineFeatherPath);
                %%% Corner info of calibration image
                obj.CornerInfo = load(CornerInfoPath);
                %%%%%%%%%%%%%%%%%%%%%%%% input necessary data }}
                if strcmp(type,'Lytro')
                    obj.sensor = struct('pixelPitch',1.4,...
                        'pixelWidth',3280, 'pixelHeight',3280, 'bitsPerPixel', 12,...
                        'd_img',10);
                    obj.mla = struct(...
                        'mla_rotation',0.0019290975760668516,...
                        'lensPitch',13.89,...%1.389859962463379e-005;
                        'sensorOffset',[0,0,25],...%[ -2.7138671874999998e-006, 5.6601560115814212e-007, 2.5000000000000001e-005];
                        'l_dis',25,...
                        'radius',5);
                    obj.MainLens = struct(...
                        'focalLength', 0.0064499998092651363,...
                        'opticalCenterOffset',[-5.8207762776874005795e-05,-1.9448425518930889666e-05]);
                elseif strcmp(type,'Illum')
                    obj.sensor = struct('pixelPitch',1.4,...
                        'pixelWidth',7728, 'pixelHeight',5368, 'bitsPerPixel', 10,...
                        'd_img',14.1);
                    obj.mla = struct(...
                        'mla_rotation',-0.0025808198843151330948,...
                        'lensPitch',20,...%2.0000000000000001636e-05;
                        'sensorOffset',[0,0,40],...%[ -4.4266057014465332508e-06, 4.2581391334533687899e-06, 3.6999999999999998114e-05];
                        'l_dis',40,...
                        'radius',7);
                    obj.MainLens = struct(...
                        'focalLength', 0.011832640061537134935,...
                        'opticalCenterOffset',[-5.8207762776874005795e-05,-1.9448425518930889666e-05]);
                    
                else
                    error('wrong input arguments');
                end
      
            elseif nargin == 1
                
            else
                error('wrong input arguments');
            end
        end
         %--------jdy 20190425
         [cornerLU, cornerUR, cornerDL, cornerDR] = export4corners(obj);
        %--------------------
    end
end

%sensor = struct('pixelPitch',1.4,'pixelWidth',7728, 'pixelHeight',5368, 'bitsPerPixel', 10);