clear all;
clc
close all;

%%% TO DO
%- Rasmus tage all calibrering ud i selvstændige funktioner
% -Rasmus i epipolar lines kan man så ikke bestemem width og height inde i
% funktionen så man ikke ebhøver at fodre den med det, når man kalder
% funktionen?

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

theta0_off_test = 0;
phi_off_test = 0;%For testing with tuning
theta_off_test = 0;

theta0 = -80.80-theta0_off_test;

Theta = [-9.5; -9.5; 10; 10; 11.5]-theta0;
% Phi = [0; 0; 0; 0; 180/pi*atan(-167/(35*25))];
 %Phi = [0; 0; 0; 0; 180/pi*atan(-163.8/(35*25))];
Phi = [0; 0; 0; 0; 0]+phi_off_test;

baseLineLength = 250;
% % 
image1 = undistortImage(image1,cameraParams);
image2 = undistortImage(image2,cameraParams);
image3 = undistortImage(image3,cameraParams);
image4 = undistortImage(image4,cameraParams);
image5 = undistortImage(image5,cameraParams);
% % 

images = {image1;image2;image3;image4;image5};
angles = [Theta Phi];

% images={};
% angles = [];


%starting values.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1     0       0       -baseLineLength    0       1       0       0       0       0       1       0       -1000    -1000    -1000    -1000   -1000    -1000    -1000    -1000    -1000    -1000];

%x = [r11,     r12,    r13,    r14,    r21,       r22,      r23,    r24,    r31,    r32,    r33,        r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
lb = [1-0.5   -0.5     -0.5     -260    -0.5     1-0.5     -0.5     -50    -0.5     -0.5     1-0.5     -100    -1400  -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400   -1400];
ub = [1+0.5   0.5      0.5      -240    0.5      1+0.5     0.5      50     0.5      0.5      1+0.5     100     -500    -500    -500    -500    -500   -500    -500    -500    -500    -500];


pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;


f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification

b0_theta = 90.3-theta0_off_test;
stepsize = -0.5;
skip = 0;
for i = 0:30%Go througt exstra 25 of the images and add them to the calibration
    try
        Theta = b0_theta+i*stepsize;
        img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
        img_1 = undistortImage(imread(img_name),cameraParams);
        %img_1 = imread(img_name);
    catch
        skip = 1;
    end
    if skip ~= 1
        Theta = Theta+i*theta_off_test;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles 
    Phi = 0 + phi_off_test;
    angles = [angles; Theta Phi];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
    images{length(images)+1,1} = img_1;
    end
    skip = 0;
end
[R,r0] = extrinsicCalibrationNolimit(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

b0_theta = 93.3-theta0_off_test;
stepsize = -0.5;
i = 0;
X = zeros(47:1)
Y = zeros(47:1)
Z = zeros(47:1)
thetam1 = 0;

submatrices = [];
positions = [];

imgXX = []
imgYY = []

for i = 0:47
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles
Theta = b0_theta+i*stepsize;
Phi = 0+phi_off_test;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
try
img_name = ['3d_straight_object\b' num2str(Theta) '.tif'];
img_1 = undistortImage(imread(img_name),cameraParams);
catch
    skip = 1;
end
if skip ~= 1
    Theta = Theta+i*theta_off_test;
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the dot
searchLineWidtPixels = 20;
[posX1,posY1] = searchEpiLine(img_1(:,:,1),imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
%plot(posX1,posY1,'x','color','b')


if posX1 <= 10 || posY1 <= 10
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
submatrices = [submatrices {subMatrix1}];
positions = [positions;xmid_1-offsetW1 ymid_1-offsetH1];
imgXX = [imgXX xmid_1];
imgYY = [imgYY ymid_1];

[x,y,z,xr,yr,xl,yl] = calcWorldPosition(Theta,Phi,xmid1_mm,ymid1_mm,f,R,r0);
X(i+1) = x;
Y(i+1) = y;
Z(i+1) = z;
end
skip = 0;

% hold on
% plot(xr,yr,'x','color','r')
% plot(xl,yl,'x','color','b')
% 
% xr-thetam1
% thetam1 = xr;
end


zzz = Z;
zzz(zzz>-1050) = -1050;
zzz(zzz<-1200) = -1200;

figure(2)
pointsize = 10;
scatter3(X, Y,Z, pointsize, zzz);
xlabel('X')
ylabel('Y')
zlabel('Z')
%axis([-400 200 -200 200 -1300 -800])
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
axis([-400 200 -1300 -1000])
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

%%
ymid5_mm
xmid5_mm


ymes5 = Y_measured(5)
zmes5 = Z_measured(5)
xmes5 = X_measured(5)

pitchCam_rad = -atan(ymid5_mm/f)+atan(ymes5/zmes5);
yawCam_rad = -atan(xmid5_mm/f)+atan(xmes5/zmes5);

v = pitchCam_rad;
R_camoff = [1 0 0; 0 cos(v) sin(v); 0 -sin(v) cos(v)];
v = yawCam_rad;
R_camoff = R_camoff * [cos(v) 0 sin(v); 0 1 0; -sin(v) 0 cos(v)];


newP = R_camoff*[X([1 3 4 5 6 7])'; Y([1 3 4 5 6 7])'; Z([1 3 4 5 6 7])'];
figure(3)
%plot3(X_measured-X_measured(1),Y_measured-Y_measured(1),Z_measured-Z_measured(1),'x')
plot3(X_measured,Y_measured,Z_measured,'x')
hold on
%plot3(X([1 3 4 5 6 7])-X(1),Y([1 3 4 5 6 7])-Y(1),Z([1 3 4 5 6 7])-Z(1),'o')
plot3(X([1 3 4 5 6 7]),Y([1 3 4 5 6 7]),Z([1 3 4 5 6 7]),'o')
plot3(newP(1,:),newP(2,:),newP(3,:),'x')
xlabel('X')
ylabel('Y')
zlabel('Z')



%Distance between the points

%p1 to p3
sqrt((X(1)-X(3))^2+(Y(1)-Y(3))^2+(Z(1)-Z(3))^2)
sqrt((X_measured(1)-X_measured(3))^2+(Y_measured(1)-Y_measured(3))^2+(Z_measured(1)-Z_measured(3))^2)

%p3 to p4
sqrt((X(3)-X(4))^2+(Y(3)-Y(4))^2+(Z(3)-Z(4))^2)
sqrt((X_measured(3)-X_measured(4))^2+(Y_measured(3)-Y_measured(4))^2+(Z_measured(3)-Z_measured(4))^2)

%p4 to p5
sqrt((X(4)-X(5))^2+(Y(4)-Y(5))^2+(Z(4)-Z(5))^2)
sqrt((X_measured(4)-X_measured(5))^2+(Y_measured(4)-Y_measured(5))^2+(Z_measured(4)-Z_measured(5))^2)

%%

%%%---------------------Code the restart movement so back to original theta----------------------



%%%---------------------Loop that countinues---------------------
x=[] %X and y coordinates of the laser. One entry pr. loop
y=[]
rms=[] %the valus should be higher than 0.95 otherwise there the picture 
%was too bad to make a gauss fit from



    %%%---------------------Take an image%pick a camera----------------------
%     pic = snapshot(cam);
    
%     pic = imread('Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg'); %Dette er bare et test billede til at debugge
%     red=pic(:,:,1);%takes just the red channel of image
%     figure()
%     imshow(red);
    
    
    %%%---------------------Get angles of laser----------------------
    %Theta = input('Enter Theta and press enter: ');
    %Phi = input('Enter Phi and press enter: ');
    %searchLineWidtPixels=input('Enter searchLineWidtPixels and press enter: ');
    
    
    
    
    %%%---------------------Search Along epipolar lines----------------------
%   [posX,posY] = searchEpiLine(red,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
    %[posX,posY]=locationDot_R_channel(red); %This is just beacuse we don't yet know the phi and theta to use in searchepilines
    
    
    
    
    
    %%%---------------------Cut out point ----------------------
    Wsub = 20;
    Hsub = 20;
    %[subMatrix_red, offsetH, offsetW] = subMatrix(red,posX,posY,Wsub,Hsub);
    
    
    
    
    
   %%%---------------Calculate point mid in image ----------------------
    %[y(counter_loop),x(counter_loop),rms(counter_loop)] = midOfMass_gauss(subMatrix_red,offsetW,offsetH);
    %yr = y(counter_loop); xr = x(counter_loop);
    
    
    
    
   %%%---------------------Calculate exact point location - Again remember units eg. mm----------------------
    %[X,Y,Z] = calcWorldPosition(Theta(1),Phi(1),xmid_1,ymid_1,f,R,r0);


    %counter_loop=counter_loop+1;

    
    %%%---------------------Move setup to new theta angel----------------------


x %prints coordinates
y




hihi = R-eye(3)


