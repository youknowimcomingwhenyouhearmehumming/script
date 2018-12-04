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
load('images_and_data_dec03/Intrinsic/cameraParams.mat')

% For external calibration run function below with 5 undistorted images of a laser dot
% Also pass the laser angles for each

imgH = cameraParams.ImageSize(1);
imgW = cameraParams.ImageSize(2);


addpath('images_and_data_dec03')
[X_measured,Y_measured,Z_measured,baseline_measured,Theta_measured,Phi_measured] = getMeasurements();


image1 = imread('images_and_data_dec03\b01.tif');
image2 = imread('images_and_data_dec03\b06.tif');
image3 = imread('images_and_data_dec03\b03.tif');
image4 = imread('images_and_data_dec03\b05.tif');
image5 = imread('images_and_data_dec03\b07.tif');
Theta = Theta_measured([1 6 3 5 7]);
Phi = Phi_measured([1 6 3 5 7]);



baseLineLength = baseline_measured;


image1 = undistortImage(image1,cameraParams);
image2 = undistortImage(image2,cameraParams);
image3 = undistortImage(image3,cameraParams);
image4 = undistortImage(image4,cameraParams);
image5 = undistortImage(image5,cameraParams);

images = {image1;image2;image3;image4;image5};
angles = [Theta(1:5,:) Phi(1:5,:)];

%starting values.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1     0       0       -250    0       1       0       0       0       0       1       0       -1350    -1350    -1300    -900   -1350    -1350    -1350    -1300    -900    -1300];
pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;
f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification

[R,r0] = extrinsicCalibration(images,angles,x0,f,baseLineLength,pix_W,pix_H);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
img_1 = undistortImage(imread('images_and_data_dec03\b01.tif'),cameraParams);
%img_2 = imread('images_and_data_dec03\b02.tif'); %Lamp is too bright
img_3 = undistortImage(imread('images_and_data_dec03\b03.tif'),cameraParams);
img_4 = undistortImage(imread('images_and_data_dec03\b04.tif'),cameraParams);
img_5 = undistortImage(imread('images_and_data_dec03\b05.tif'),cameraParams);
img_6 = undistortImage(imread('images_and_data_dec03\b06.tif'),cameraParams);
img_7 = undistortImage(imread('images_and_data_dec03\b07.tif'),cameraParams);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles
Theta_measured;
Phi_measured;
searchLineWidtPixels = 10;

%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the dot
[posX1,posY1] = searchEpiLine(img_1(:,:,1),imgW,imgH,Theta_measured(1),Phi_measured(1),R,r0,f,searchLineWidtPixels,pix_W,pix_H);
[posX3,posY3] = searchEpiLine(img_3(:,:,1),imgW,imgH,Theta_measured(3),Phi_measured(3),R,r0,f,searchLineWidtPixels,pix_W,pix_H);
[posX4,posY4] = searchEpiLine(img_4(:,:,1),imgW,imgH,Theta_measured(4),Phi_measured(4),R,r0,f,searchLineWidtPixels,pix_W,pix_H);
[posX5,posY5] = searchEpiLine(img_5(:,:,1),imgW,imgH,Theta_measured(5),Phi_measured(5),R,r0,f,searchLineWidtPixels,pix_W,pix_H);
[posX6,posY6] = searchEpiLine(img_6(:,:,1),imgW,imgH,Theta_measured(6),Phi_measured(6),R,r0,f,searchLineWidtPixels,pix_W,pix_H);
[posX7,posY7] = searchEpiLine(img_7(:,:,1),imgW,imgH,Theta_measured(7),Phi_measured(7),R,r0,f,searchLineWidtPixels,pix_W,pix_H);

%%%%%%%%%%%%%%%%%%%%%%%%%%Cut out the dot
Wsub = 10;
Hsub = 10;
[subMatrix1, offsetH1, offsetW1] = subMatrix(img_1(:,:,1),posX1,posY1,Wsub,Hsub);
[subMatrix3, offsetH3, offsetW3] = subMatrix(img_3(:,:,1),posX3,posY3,Wsub,Hsub);
[subMatrix4, offsetH4, offsetW4] = subMatrix(img_4(:,:,1),posX4,posY4,Wsub,Hsub);
[subMatrix5, offsetH5, offsetW5] = subMatrix(img_5(:,:,1),posX5,posY5,Wsub,Hsub);
[subMatrix6, offsetH6, offsetW6] = subMatrix(img_6(:,:,1),posX6,posY6,Wsub,Hsub);
[subMatrix7, offsetH7, offsetW7] = subMatrix(img_7(:,:,1),posX7,posY7,Wsub,Hsub);

%%%%%%%%%%%%%%%%%%%%%%%%%%%Find mid of the dot
offsetW = 0;
offsetH = 0;

[ymid_1,xmid_1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
[ymid_3,xmid_3] = midOfMass_gauss(subMatrix3,offsetW3,offsetH3);
[ymid_4,xmid_4] = midOfMass_gauss(subMatrix4,offsetW4,offsetH4);
[ymid_5,xmid_5] = midOfMass_gauss(subMatrix5,offsetW5,offsetH5);
[ymid_6,xmid_6] = midOfMass_gauss(subMatrix6,offsetW6,offsetH6);
[ymid_7,xmid_7] = midOfMass_gauss(subMatrix7,offsetW7,offsetH7);

%Convert from pixel value to mm and move origo to middle
xmid1_mm = (xmid_1-imgW/2)*pix_W;
ymid1_mm = (ymid_1-imgH/2)*pix_H;
xmid3_mm = (xmid_3-imgW/2)*pix_W;
ymid3_mm = (ymid_3-imgH/2)*pix_H;
xmid4_mm = (xmid_4-imgW/2)*pix_W;
ymid4_mm = (ymid_4-imgH/2)*pix_H;
xmid5_mm = (xmid_5-imgW/2)*pix_W;
ymid5_mm = (ymid_5-imgH/2)*pix_H;
xmid6_mm = (xmid_6-imgW/2)*pix_W;
ymid6_mm = (ymid_6-imgH/2)*pix_H;
xmid7_mm = (xmid_7-imgW/2)*pix_W;
ymid7_mm = (ymid_7-imgH/2)*pix_H;

figure(1)
imshow(img_4(:,:,1))
hold on
plot(xmid_4,ymid_4,'x')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find world coordinate

X=zeros(7,1);
Y=zeros(7,1);
Z=zeros(7,1);

[X(1),Y(1),Z(1)] = calcWorldPosition(Theta_measured(1),Phi_measured(1),xmid1_mm,ymid1_mm,f,R,r0)
[X(3),Y(3),Z(3)] = calcWorldPosition(Theta_measured(3),Phi_measured(3),xmid3_mm,ymid3_mm,f,R,r0)
[X(4),Y(4),Z(4)] = calcWorldPosition(Theta_measured(4),Phi_measured(4),xmid4_mm,ymid4_mm,f,R,r0)
[X(5),Y(5),Z(5)] = calcWorldPosition(Theta_measured(5),Phi_measured(5),xmid5_mm,ymid5_mm,f,R,r0)
[X(6),Y(6),Z(6)] = calcWorldPosition(Theta_measured(6),Phi_measured(6),xmid6_mm,ymid6_mm,f,R,r0)
[X(7),Y(7),Z(7)] = calcWorldPosition(Theta_measured(7),Phi_measured(7),xmid7_mm,ymid7_mm,f,R,r0)


figure(2)
plot3(X_measured,Y_measured,Z_measured,'x')
hold on
plot3(X([1 3 4 5 6 7]),Y([1 3 4 5 6 7]),Z([1 3 4 5 6 7]),'o')
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




