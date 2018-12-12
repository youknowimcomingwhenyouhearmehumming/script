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
%image5 = imread('kalibrering_6_dec5.tif');
image5 = imread('b92.3.tif');

theta0 = -80.8;
Theta = [-9.5; -9.5; 10; 10; 11.5]-theta0;
%Phi = [0; 0; 0; 0; 180/pi*atan(-167/(35*25))];
%Phi = [0; 0; 0; 0; 180/pi*atan(-162/(35*25))];
Phi = [0; 0; 0; 0; 0];

baseLineLength = 250;

image1 = undistortImage(image1,cameraParams);
image2 = undistortImage(image2,cameraParams);
image3 = undistortImage(image3,cameraParams);
image4 = undistortImage(image4,cameraParams);
image5 = undistortImage(image5,cameraParams);

images = {image1;image2;image3;image4;image5};
angles = [Theta Phi];

%starting values.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1     0       0       -250    0       1       0       0       0       0       1       0       -1000    -1000    -1000    -1000   -1000    -1000    -1000    -1000    -1000    -1000];

%x = [r11,     r12,    r13,    r14,    r21,       r22,      r23,    r24,    r31,    r32,    r33,        r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
lb = [1-0.5   -0.5     -0.5     -260    -0.5     1-0.5     -0.5     -50    -0.5     -0.5     1-0.5     -100    -1400  -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400];
ub = [1+0.5   0.5      0.5      -240    0.5      1+0.5     0.5      50     0.5      0.5      1+0.5     100     -500    -500    -500    -500    -500   -500    -500    -500    -500    -500];


pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;


f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification

b0_theta = 70.8;
stepsize = 0.5;
skip = 0;
for i = 0:20%Go througt exstra 25 of the images and add them to the calibration
    try
        Theta = b0_theta+i*stepsize;
        img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
        img_1 = undistortImage(imread(img_name),cameraParams);
    catch
        skip = 1;
    end
    if skip ~= 1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles 
    Phi = 0;
    angles = [angles; Theta Phi];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
    images{length(images)+1,1} = img_1;
    end
    skip = 0;
end
[R,r0] = extrinsicCalibrationNolimit(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

b0_theta = 70.8;
stepsize = 0.5;
number_of_pictures=47; 
phi_0_angel=10; 
Angel_between_phi_dots=5;
number_of_dots_in_fane=5;

i = 0;
X = zeros(number_of_pictures:1)
Y = zeros(number_of_pictures:1)
Z = zeros(number_of_pictures:1)
thetam1 = 0;
figure(6)
for i = 0:number_of_pictures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles
for j = 0:number_of_dots_in_fane
Phi = phi_0_angel+j*Angel_between_phi_dots;
Theta = b0_theta+i*stepsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
try
img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
img_1 = undistortImage(imread(img_name),cameraParams);
catch
    skip = 1;
end
if skip ~= 1


%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the dot
searchLineWidtPixels = 20;
[posX1,posY1] = searchEpiLine(img_1(:,:,1),imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
if posX1 <= 10 || posY1 <= 10
    break;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%Cut out the dot
Wsub = 40;
Hsub = 40;
[subMatrix1, offsetH1, offsetW1] = subMatrix(img_1(:,:,1),posX1,posY1,Wsub,Hsub);
%%%%%%%%%%%%%%%%%%%%%%%%%%%Find mid of the dot
[ymid_1,xmid_1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
%Convert from pixel value to mm and move origo to middle
xmid1_mm = (xmid_1-imgW/2)*pix_W;
ymid1_mm = (ymid_1-imgH/2)*pix_H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find world coordinate


[x,y,z,xr,yr,xl,yl] = calcWorldPosition(Theta,Phi,xmid1_mm,ymid1_mm,f,R,r0);
X(i+1) = x;
Y(i+1) = y;
Z(i+1) = z;
end
skip = 0;
end

end


% hold on
% plot(xr,yr,'x','color','r')
% plot(xl,yl,'x','color','b')
% 
% xr-thetam1
% thetam1 = xr;



figure(2)
plot3(X,Y,Z,'o')
xlabel('X')
ylabel('Y')
zlabel('Z')
%axis([-500 500 -500 500 -1500 -500])
grid on


