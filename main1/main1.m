clear;
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%1 - Calibration of camera and laser

%For intrinsic, run the camera calibration app and take pictures. Remember
%to enable tangential distortion and skew. Or use the saved cameraParams
%variable.
load('CameraParams.mat')

% For external calibration run function below with at 5 images of a laser dot
% Also pass the laser angles for each

angles = [  theta1 phi1;
            theta2 phi2;
            theta3 phi3;
            theta4 phi4;
            theta5 phi5]

images = {imread('extrinsic_calibration_pictures/b1.jpg') imread('extrinsic_calibration_pictures/b2.jpg') imread('extrinsic_calibration_pictures/b5.jpg')};
%worldcoordinates are:  [X1 X2 X3]
%                       [Y1 Y2 Y3]
%                       [Z1 Z2 Z3]
%units in mm
%worldCoordinatesXYZ = [0 -300 250;0 0 66;-914.5 -914.5 -914.5];
%angles = [Theta1 Theta2 Theta3;Phi1 Phi2 Phi3]
%angles = [82 100 86.5;0 0 4.13];

%[R,r0] = externalCalibration(images,worldCoordinatesXYZ,angles)
%or maybe [rotationMatrix,translationVector] = extrinsics(imagePoints,worldPoints,cameraParams)
%but if we need to measure that much it is better just to set it straight
%in the first place.
R = eye(3);
r0 = [-1;0;0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Setup
%pick a camera
%webcamlist
%cam = webcam('C922')

%%%%%%%%%Take an image
pic = snapshot(cam);
%%%%%%%%%Get angles of laser
Theta = 0;
Phi = 0;
%%%%%%%%%Search Along epipolar lines
[posX,posY] = searchEpiLine(imageData,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);

%%%%%%%%%Cut out point 

%%%%%%%%%Calculate point mid in image - Remember to undistort the cutouts.
%%%%%%%%%Also calc offset with R and r0.

%%%%%%%%%Calculate exact point location










