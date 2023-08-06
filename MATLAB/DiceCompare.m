% Accuracy test:
% Author: Ryan

%=========================================================================%
% 1.Creat a folders which named COMPARE
% 2.Creat four folders: VALID_SEGMENT, TRAIN_1, TRAIN_2, TRAIN_3
% 3.Creat three folders in TRAIN_1, TRAIN_2 and TRAIN_3 folders respectively
%   named predict_images_UNET_TRAIN_"num", 
%         predict_images_UNET_ATTEN_TRAIN_"num",
%         predict_images_VGG_UNET_ATTEN_TRAIN_"num",
% 4.Place the label to VALID_SEGMENT
% 5.Place the trained labels in the corresponding folder.
%=========================================================================%

clc
clear all
close all
%store dice data
ATTEN_DICE_LIST = zeros(12,8);
UNET_DICE_LIST = zeros(12,8);
VGG_DICE_LIST = zeros(12,8);
ALL_DICE = [];
for q = 1:3
    for i = 1:8
        doc_num = i;
        train_num = q;
        %check index of image of this dir
        doc_path = ['./COMPARE/VALID_SEGMENT/',num2str(i),'/'];
        pice = dir(strcat(doc_path,'*.png'));
        Num_img = length(pice);
    
        %SEGMENT IMAGE
        image_path = ['./COMPARE/VALID_SEGMENT/',num2str(doc_num),'/',num2str(1),'_valid.png'];
        image_0 = double(imread(image_path));
        Img = cat(3,image_0);        
        for j = 2:Num_img
            path_index = j;
            image_path = ['./COMPARE/VALID_SEGMENT/',num2str(doc_num),'/',num2str(path_index),'_valid.png'];        
            image = double(imread(image_path));
            Img = cat(3,Img,image);       
        end
    
        %ATTENTION UNET RESULT
        Atten_path0 = ['./COMPARE/TRAIN_',num2str(q ...
            ),'/predict_images_UNET_ATTEN_TRAIN_',num2str(q),'/',num2str(doc_num),'/1_valid.png'];
        atten_0 = double(rgb2gray(imread(Atten_path0)));
        ATTEN = cat(3,atten_0);
        for m = 2:Num_img
            path_index = m;    
            atten_path = ['./COMPARE/TRAIN_',num2str(q),'/predict_images_UNET_ATTEN_TRAIN_',num2str(q),'/',num2str( ...
                doc_num),'/',num2str(path_index),'_valid.png'];        
            atten_result = double(rgb2gray(imread(atten_path)));
            ATTEN = cat(3,ATTEN,atten_result);
        end
    
        %UNET RESULT
        unet_path0 = ['./COMPARE/TRAIN_',num2str(q ...
            ),'/predict_images_UNET_TRAIN_',num2str(q),'/',num2str(doc_num),'/1_valid.png'];
        unet_0 = double(rgb2gray(imread(unet_path0)));
        Unet = cat(3,unet_0);
        for m = 2:Num_img
            path_index = m;    
            unet_path = ['./COMPARE/TRAIN_',num2str(q),'/predict_images_UNET_TRAIN_',num2str( ...
                q),'/',num2str(doc_num),'/',num2str(path_index),'_valid.png'];    
            unet_result = double(rgb2gray(imread(unet_path)));
            Unet = cat(3,Unet,unet_result);
        end
    
    
        %VGG-UNET-ATTENTION RESULT
        VGG_path0 = ['./COMPARE/TRAIN_',num2str(q ...
            ),'/predict_images_VGG_UNET_ATTEN_TRAIN_',num2str(q),'/',num2str(doc_num),'/1_valid.png'];
        VGG_0 = double(rgb2gray(imread(VGG_path0)));
        VGG = cat(3,VGG_0);
        for m = 2:Num_img
            path_index = m;    
            VGG_path = ['./COMPARE/TRAIN_',num2str(q ...
                ),'/predict_images_VGG_UNET_ATTEN_TRAIN_',num2str(q),'/',num2str(doc_num),'/',num2str(path_index),'_valid.png'];    
            VGG_result = double(rgb2gray(imread(VGG_path)));
            VGG = cat(3,VGG,VGG_result);
        end

    
    
        %check number of classes
        ATTEN_num_class = size(unique(ATTEN),1);
        Img_num_class = size(unique(Img),1);
        Unet_num_class = size(unique(Unet),1);
        VGG_num_class = size(unique(VGG),1);
    
        %dice
        %UNET ATTENTION DICE
        ATTEN_DICE = dice(ATTEN,Img);
    
        %UNET DICE
        UNET_DICE = dice(Unet,Img);
    
        %UNET VGG ATTENTION DICE
        VGG_DICE = dice(VGG,Img);
    
        %ATTEN_DICE length
        atten_dice_length = size(ATTEN_DICE,1);
    
        %UNET_DICE length
        unet_dice_length = size(UNET_DICE,1);
    
        %VGG_UNET ATTENTION DICE LENGTH
        vgg_dice_length = size(VGG_DICE,1);
    
        %sotre the dice data

        ATTEN_DICE_LIST(1:atten_dice_length,i) = ATTEN_DICE;
        UNET_DICE_LIST(1:unet_dice_length,i) = UNET_DICE;
        VGG_DICE_LIST(1:vgg_dice_length,i) = VGG_DICE;
    end

    %save all dice
    if q == 1
            ALL_DICE_1 = [UNET_DICE_LIST;ATTEN_DICE_LIST;VGG_DICE_LIST];
        elseif q == 2
            ALL_DICE_2 = [UNET_DICE_LIST;ATTEN_DICE_LIST;VGG_DICE_LIST];
        elseif q == 3
            ALL_DICE_3 = [UNET_DICE_LIST;ATTEN_DICE_LIST;VGG_DICE_LIST];
    end

end
ALL_DICE = cat(2,ALL_DICE_1,ALL_DICE_2,ALL_DICE_3);
 %computing average
ALL_DICE_w = size(ALL_DICE_1,1);
ALL_DICE_h = size(ALL_DICE_1,2);
AVERAGE_VALUE_DICE_LIST = zeros(ALL_DICE_w,ALL_DICE_h);


for m = 1:ALL_DICE_w
    for n = 1:ALL_DICE_h
        average_value = (ALL_DICE_1(m,n) + ALL_DICE_2(m,n) + ALL_DICE_3(m,n))/3;
        AVERAGE_VALUE_DICE_LIST(m,n) = average_value;
    end
end



%% check the dice list Obey the normal distribution
clc
% by pixel
% UNET_DICE
for k = 1:12
    [h,p]=lillietest(UNET_DICE_LIST(k,:));
    if h==0 && p>0.05
        disp(['UNET: Class ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end

disp('================================================================')

% UNET_ATTEN_DICE
for k = 1:12
    [h,p]=lillietest(ATTEN_DICE_LIST(k,:));
    if h==0 && p>0.05
        disp(['UNET_ATTENTION: Class ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end

disp('================================================================')

% VGG_UNET_ATTEN_DICE
for k = 1:12
    [h,p]=lillietest(VGG_DICE_LIST(k,:));
    if h==0 && p>0.05
        disp(['VGG_UNET_ATTENTION: Class ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end

disp('================================================================')

% by patient
%UNET
for k = 1:8
    [h,p]=lillietest(UNET_DICE_LIST(1:12,k));
    if h==0 && p>0.05
        disp(['UNET: Patient ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end

disp('================================================================')

%UNET ATTENTION
for k = 1:8
    [h,p]=lillietest(ATTEN_DICE_LIST(1:12,k));
    if h==0 && p>0.05
        disp(['UNET ATTENTION: Patient ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end

disp('================================================================')

%VGG UNET ATTENTION
for k = 1:8
    [h,p]=lillietest(VGG_DICE_LIST(1:12,k));
    if h==0 && p>0.05
        disp(['VGG UNET ATTENTION: Patient ',num2str(k),' obey the normal distribution']);
    else
        disp(['H: ',num2str(h), 'P: ',num2str(p)])
    end
end




