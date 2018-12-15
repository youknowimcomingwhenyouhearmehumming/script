clear all;
clc
close all;
%%%%%%%Calibreringsdel. Vigtigt bare at få R,r0 med
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%1 - Calibration of camera and laser
% 
% %For intrinsic, run the camera calibration app and take pictures. Remember
% %to enable tangential distortion and skew. Or use the saved cameraParams
% %variable.
% 
% load('cameraParams.mat') % We use the cameraParams found ealier, hopefully noone tuched the camera
% 
% imgH = cameraParams.ImageSize(1);
% imgW = cameraParams.ImageSize(2);
% 
% addpath('Calibration');
% addpath('3d_straight_object');
% 
% image1 = imread('kalibrering_6_dec0.tif');
% image2 = imread('kalibrering_6_dec1.tif');
% image3 = imread('kalibrering_6_dec2.tif');
% image4 = imread('kalibrering_6_dec3.tif');
% %image5 = imread('kalibrering_6_dec5.tif');
% image5 = imread('b92.3.tif');
% 
% theta0 = -80.8;
% Theta = [-9.5; -9.5; 10; 10; 11.5]-theta0;
% %Phi = [0; 0; 0; 0; 180/pi*atan(-167/(35*25))];
% %Phi = [0; 0; 0; 0; 180/pi*atan(-162/(35*25))];
% Phi = [0; 0; 0; 0; 0];
% 
% baseLineLength = 250;
% 
% image1 = undistortImage(image1,cameraParams);
% image2 = undistortImage(image2,cameraParams);
% image3 = undistortImage(image3,cameraParams);
% image4 = undistortImage(image4,cameraParams);
% image5 = undistortImage(image5,cameraParams);
% 
% images = {image1;image2;image3;image4;image5};
% angles = [Theta Phi];
% 
% %starting values.
% %x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
% x0 = [1     0       0       -250    0       1       0       0       0       0       1       0       -1000    -1000    -1000    -1000   -1000    -1000    -1000    -1000    -1000    -1000];
% 
% %x = [r11,     r12,    r13,    r14,    r21,       r22,      r23,    r24,    r31,    r32,    r33,        r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
% lb = [1-0.5   -0.5     -0.5     -260    -0.5     1-0.5     -0.5     -50    -0.5     -0.5     1-0.5     -100    -1400  -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400];
% ub = [1+0.5   0.5      0.5      -240    0.5      1+0.5     0.5      50     0.5      0.5      1+0.5     100     -500    -500    -500    -500    -500   -500    -500    -500    -500    -500];
% 
% 
% pix_W = 2.2*10^-3;
% pix_H = 2.2*10^-3;
% 
% 
% f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification
% 
% b0_theta = 70.8;
% stepsize = 0.5;
% skip = 0;
% for i = 0:20%Go througt exstra 25 of the images and add them to the calibration
%     try
%         Theta = b0_theta+i*stepsize;
%         img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
%         img_1 = undistortImage(imread(img_name),cameraParams);
%     catch
%         skip = 1;
%     end
%     if skip ~= 1
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles 
%     Phi = 0;
%     angles = [angles; Theta Phi];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
%     images{length(images)+1,1} = img_1;
%     end
%     skip = 0;
% end
% [R,r0] = extrinsicCalibrationNolimit(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub);

R=
ro=

% xxx spørg rasmus om han mener denne implementering er ok for næste to
% linjer
rod_name_of_files='3d_straight_object\a';
[X1,Y1,Z1] = full_scan_function(R,r0,rod_name_of_files);

figure(2)
plot3(X1,Y1,Z1,'o')
xlabel('X1')
ylabel('Y1')
zlabel('Z1')
%axis([-500 500 -500 500 -1500 -500])
grid on


rod_name_of_files='3d_straight_object\b'; 
[X2,Y2,Z2] = full_scan_function(R,r0,rod_name_of_files);

figure(3)
plot3(X2,Y2,Z3,'o')
xlabel('X2')
ylabel('Y2')
zlabel('Z2')
%axis([-500 500 -500 500 -1500 -500])
grid on

safety_distance=10; 
Taget_1_X=[]; %xxx vær opmærksom på om den laver flere target punkter for det er sådan ser ikke meningen
Taget_1_Y=[];
Taget_1_Z=[];
counter=1;
for i=1:max(size(X1),size(X2))
    try %xxx rasmus hvordan implementeres try funktionen?
    if((X2(i) <= X1(i)-safety_distance) && (X2(i) >= X1(i)+safety_distance))
        if((Y2(i) <= Y1(i)-safety_distance) && (Y2(i) >= Y1(i)+safety_distance))
            if((Z2(i) <= Z1(i)-safety_distance) && (Z2(i) >= Z(i)+safety_distance))
                Taget_1_X(counter));
                Taget_1_Y(counter);
                Taget_1_Z(counter);
                counter=counter+1;
            end 
        end 
    end
    catch 
    end
    
end 


rod_name_of_files='3d_straight_object\b'; 
[X3,Y3,Z3] = full_scan_function(R,r0,rod_name_of_files);
for i=1:max(size(X2),size(X3))
    try %xxx rasmus hvordan implementeres try funktionen?
    if((X3(i) <= X2(i)-safety_distance) && (X3(i) >= X2(i)+safety_distance))
        if((Y3(i) <= Y2(i)-safety_distance) && (Y3(i) >= Y2(i)+safety_distance))
            if((Z3(i) <= Z2(i)-safety_distance) && (Z3(i) >= Z(i)2+safety_distance))
                Taget_2_X(counter));
                Taget_2_Y(counter);
                Taget_2_Z(counter);
                counter=counter+1;
            end 
        end 
    end 
    catch 
    end
end

figure(4)
plot3(X3,Y3,Z3,'o')
xlabel('X3')
ylabel('Y3')
zlabel('Z3')
%axis([-500 500 -500 500 -1500 -500])
grid on

[x_final,y_final,z_final] = prediction(Taget_1_X,Taget_1_Y,Taget_1_Z,Taget_2_X,Taget_2_Y,Taget_2_Z)


% xxx rasmus hvordan beregnes vinklen for laser så den rammer den endelige
% position