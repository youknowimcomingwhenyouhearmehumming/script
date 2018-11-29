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
load('CameraParams.mat')

% For external calibration run function below with 5 undistorted images of a laser dot
% Also pass the laser angles for each
theta1 = 74;
phi1 = 0;
theta2 = 93;
phi2 = 0;
theta3 = 59;
phi3 = 0;
theta4 = 71;
phi4 = 0;
theta5 = 90;
phi5 = 4;

angles = [  theta1 phi1;
            theta2 phi2;
            theta3 phi3;
            theta4 phi4;
            theta5 phi5];
        
image1 = undistortImage(imread('extrinsic_calibration_pictures/b1.jpg'),cameraParams);
image2 = undistortImage(imread('extrinsic_calibration_pictures/b2.jpg'),cameraParams);
image3 = undistortImage(imread('extrinsic_calibration_pictures/b3.jpg'),cameraParams);
image4 = undistortImage(imread('extrinsic_calibration_pictures/b4.jpg'),cameraParams);
image5 = undistortImage(imread('extrinsic_calibration_pictures/b5.jpg'),cameraParams);

images = {image1;image2;image3;image4;image5};

%starting values.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1.1     0       0       -250    0       1       0       0       0       0       1       0       -900    -900    -900    -900    -700    -900    -900    -900    -700    -900];
pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;
f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification
baseLineLength = 250;

[R,r0] = extrinsicCalibration(images,angles,x0,f,baseLineLength,pix_W,pix_H);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


%%%---------------------Code the restart movement so back to original theta----------------------



%%%---------------------Loop that countinues---------------------
x=[] %X and y coordinates of the laser. One entry pr. loop
y=[]

counter_loop=1;
while true
        if counter_loop=counter_loop>10
            break
        end


    %%%---------------------Take an image%pick a camera----------------------
    %webcamlist
    %cam = webcam('C922')
    pic = snapshot(cam);
    red=pic(:,:,1);%takes just the red channel of image

    %%%---------------------Get angles of laser----------------------
    Theta = 0;
    Phi = 0;

    %%%---------------------Search Along epipolar lines----------------------
    [posX,posY] = searchEpiLine(red,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);

    %%%---------------------Cut out point ----------------------
    Wsub = 30;
    Hsub = 20;
    [subMatrix_red, offsetH, offsetW] = subMatrix(red,posX,posY,subMatrixW,subMatrixH)

    
   %%%---------------Calculate point mid in image - Remember to undistort the cutouts----------------------
    [y(counter_loop),x(counter_loop)] = midOfMass(subMatrix_red,Wsub,Hsub,offsetW,offsetH)

    
   %%%---------------------Calculate exact point location - Again remember units eg. mm----------------------
    [X,Y,Z] = calcWorldPosition(Theta,Phi,xr,yr,f,R,r0);


    counter_loop=counter_loop+1;

    
    %%%---------------------Move setup to new theta angel----------------------

end 

x %prints coordinates
y




