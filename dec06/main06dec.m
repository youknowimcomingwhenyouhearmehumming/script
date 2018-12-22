clear all;
clc
close all;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%1 - Calibration of camera and laser

%For intrinsic, run the camera calibration app and take pictures. Remember
%to enable tangential distortion and skew. Or use the saved cameraParams
%variable.
load('cameraParams.mat') % We use the cameraParams found ealier, hopefully noone tuched the camera

imgH = cameraParams.ImageSize(1);
imgW = cameraParams.ImageSize(2);

addpath('Calibration');
addpath('3d_straight_object');

image1 = imread('kalibrering_6_dec0.tif');
image2 = imread('kalibrering_6_dec1.tif');
image3 = imread('kalibrering_6_dec2.tif');
image4 = imread('kalibrering_6_dec3.tif');
image5 = imread('b92.3.tif');

theta0 = -80.80;%From the experiament

Theta = [-9.5; -9.5; 10; 10; 11.5]-theta0;
Phi = [0; 0; 0; 0; 0];

baseLineLength = 250;

%undistorting the 5 calibration images
image1 = undistortImage(image1,cameraParams);
image2 = undistortImage(image2,cameraParams);
image3 = undistortImage(image3,cameraParams);
image4 = undistortImage(image4,cameraParams);
image5 = undistortImage(image5,cameraParams);


images = {image1;image2;image3;image4;image5};
angles = [Theta Phi];


%starting values for the extrinsic calibration.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1     0       0       -baseLineLength    0       1       0       0       0       0       1       0       -1000    -1000    -1000    -1000   -1000    -1000    -1000    -1000    -1000    -1000];

%Boundaries
%x = [r11,     r12,    r13,    r14,    r21,       r22,      r23,    r24,    r31,    r32,    r33,        r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
lb = [1-0.5   -0.5     -0.5     -260    -0.5     1-0.5     -0.5     -50    -0.5     -0.5     1-0.5     -100    -1400  -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400];
ub = [1+0.5   0.5      0.5      -240    0.5      1+0.5     0.5      50     0.5      0.5      1+0.5     100     -500    -500    -500    -500    -500   -500    -500    -500    -500    -500];

%From camera datasheet 
pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;

%focal length
f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification


%making a loop to add extra images on top of the 5 already defined
b0_theta = 90.3-theta0_off_test;
stepsize = -0.5;
skip = 0;
for i = 0:20%Go througt exstra 20 of the images and add them to the calibration
    try %if the image could not be found the loop is skipped
        Theta = b0_theta+i*stepsize;
        img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
        img_1 = undistortImage(imread(img_name),cameraParams);
        %img_1 = imread(img_name);
    catch
        skip = 1;
    end
    if skip ~= 1
        Theta = Theta+i;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles 
    Phi = 0;
    angles = [angles; Theta Phi];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
    images{length(images)+1,1} = img_1;
    end
    skip = 0;
end

%run the extrinsic calibration
[R,r0] = extrinsicCalibrationNolimit(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

%Prepare to loop throug the images named after their theta angel
b0_theta = 93.3;
stepsize = -0.5;
i = 0;
X = zeros(47:1)
Y = zeros(47:1)
Z = zeros(47:1)
thetam1 = 0;

%used for plotting
submatrices = [];
positions = [];

for i = 0:47
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles
Theta = b0_theta+i*stepsize;
Phi = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
try %if the image does not exist skip
img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
img_1 = undistortImage(imread(img_name),cameraParams);
catch
    skip = 1;
end
if skip ~= 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the dot
searchLineWidtPixels = 20;
[posX1,posY1] = searchEpiLine(img_1(:,:,1),imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);

if posX1 <= 10 || posY1 <= 10%if error
    break;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%Cut out the dot
Wsub = 20;
Hsub = 20;
[subMatrix1, offsetH1, offsetW1] = subMatrix(img_1(:,:,1),posX1,posY1,Wsub,Hsub);
%%%%%%%%%%%%%%%%%%%%%%%%%%%Find mid of the dot
[ymid_1,xmid_1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
%Convert from pixel value to mm and move origo to middle
xmid1_mm = (xmid_1-imgW/2)*pix_W;
ymid1_mm = (ymid_1-imgH/2)*pix_H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find world coordinate

%Forplotting
% submatrices = [submatrices {subMatrix1}];
% positions = [positions;xmid_1-offsetW1 ymid_1-offsetH1];

[x,y,z] = calcWorldPosition(Theta,Phi,xmid1_mm,ymid1_mm,f,R,r0);
X(i+1) = x;
Y(i+1) = y;
Z(i+1) = z;
end
skip = 0;
end



%% The rest is just plotting
zzz = Z;
zzz(zzz>-1050) = -1050;
zzz(zzz<-1200) = -1200;

figure(2)
pointsize = 10;
scatter3(X, Y,Z, pointsize, zzz);
xlabel('X')
ylabel('Y')
zlabel('Z')
axis([-400 200 -200 200 -1300 -800])
grid on
title('World position of scan along plane surface')

figure(7)
subplot(1,2,1)
plot(X(X~=0),Y(Y~=0),'o')
xlabel('X')
ylabel('Y')
axis([-400 200 -50 50])
grid on
title('Camera POW')

subplot(1,2,2)
plot(X,Z,'o')
xlabel('X')
ylabel('Z')
axis([-400 200 -1150 -1000])
grid on
title('Top view')

a = [ones(length(imgXX),1) imgXX']\imgYY'

figure(8)
plot(imgXX,-imgYY,'x')
hold on
plot(1:2000,-a(2)*(1:2000)-a(1))
title('Locations of points in image with linear regression')
xlabel('X pixel value')
xlabel('Y pixel value')

figure(3)
for i = 1:16
    subplot(4,4,i)
    imshow(submatrices{i})
    hold on
    plot(positions(i,1),positions(i,2),'x','color','b','LineWidth',2)
end

axx1 = R*[10;0;0]
axx2 = R*[0;10;0]
axx3 = R*[0;0;10]
figure(4)
plot3([0 10],[0 0],[0 0])
hold on
plot3([0 0],[0 10],[0 0])
plot3([0 0],[0 0],[0 10])

plot3([0 axx1(1)],[0 axx1(2)],[0 axx1(3)])
plot3([0 axx2(1)],[0 axx2(2)],[0 axx2(3)])
plot3([0 axx3(1)],[0 axx3(2)],[0 axx3(3)])
xlabel('X')
ylabel('Y')

zlabel('Z')
