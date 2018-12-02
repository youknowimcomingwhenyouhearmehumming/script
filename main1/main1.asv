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
cameraParams.ImageSize = [480 640];

% For external calibration run function below with 5 undistorted images of a laser dot
% Also pass the laser angles for each
run('TestImages30_11\Measurements.m')

imgW = 640;
imgH = 480;
xoff = 92;
yoff = 33;

image1 = imread('TestImages30_11\billede1.png');
image2 = imread('TestImages30_11\billede2.png');
image3 = imread('TestImages30_11\billede3.png');
image4 = imread('TestImages30_11\billede4.png');
image5 = imread('TestImages30_11\billede5.png');

image1 = image1(yoff:yoff+imgH-1,xoff:xoff+imgW-1,:);
image2 = image2(yoff:yoff+imgH-1,xoff:xoff+imgW-1,:);
image3 = image3(yoff:yoff+imgH-1,xoff:xoff+imgW-1,:);
image4 = image4(yoff:yoff+imgH-1,xoff:xoff+imgW-1,:);
image5 = image5(yoff:yoff+imgH-1,xoff:xoff+imgW-1,:);

image1 = undistortImage(image1,cameraParams);
image2 = undistortImage(image2,cameraParams);
image3 = undistortImage(image3,cameraParams);
image4 = undistortImage(image4,cameraParams);
image5 = undistortImage(image5,cameraParams);

images = {image1;image2;image3;image4;image5};
angles = [Theta(1:5,:) Phi(1:5,:)];

%starting values.
%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
x0 = [1     0       0       -190    0       1       0       -18       0       0       1       0       -1000    -1000    -500    -1000    -1000    -1000    -1000    -500    -1000    -1000];
pix_W = 2.2*10^-3;
pix_H = 2.2*10^-3;
f = (cameraParams.IntrinsicMatrix(1,1)*pix_W + cameraParams.IntrinsicMatrix(2,2)*pix_H)/2; %the mean of the calculatet f from y and x magnification
baseLineLength = sqrt(dot(r0_measured,r0_measured));


[R,r0] = extrinsicCalibration(images,angles,x0,f,baseLineLength,pix_W,pix_H);



% camlist = webcamlist
% cam = webcam('C922')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


%%%---------------------Code the restart movement so back to original theta----------------------



%%%---------------------Loop that countinues---------------------
x=[] %X and y coordinates of the laser. One entry pr. loop
y=[]
rms=[] %the valus should be higher than 0.95 otherwise there the picture 
%was too bad to make a gauss fit from



counter_loop=1;
while true
        if counter_loop==counter_loop>10
            break
        end


    %%%---------------------Take an image%pick a camera----------------------
%     pic = snapshot(cam);
    
    pic = imread('Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg'); %Dette er bare et test billede til at debugge
    red=pic(:,:,1);%takes just the red channel of image
    figure()
    imshow(red);
    
    
    
    %%%---------------------Get angles of laser----------------------
    Theta = input('Enter Theta and press enter: ');
    Phi = input('Enter Phi and press enter: ');
    searchLineWidtPixels=input('Enter searchLineWidtPixels and press enter: ');
    %%%---------------------Search Along epipolar lines----------------------
%     [posX,posY] = searchEpiLine(red,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
    [posX,posY]=locationDot_R_channel(red); %This is just beacuse we don't yet know the ph and theta to use in searchepilines
    
    %%%---------------------Cut out point ----------------------
    Wsub = 30;
    Hsub = 20;
    [subMatrix_red, offsetH, offsetW] = subMatrix(red,posX,posY,Wsub,Hsub);

    
   %%%---------------Calculate point mid in image - Remember to undistort the cutouts----------------------
    [y(counter_loop),x(counter_loop),rms(counter_loop)] = midOfMass_gauss(subMatrix_red,offsetW,offsetH)

    
   %%%---------------------Calculate exact point location - Again remember units eg. mm----------------------
    [X,Y,Z] = calcWorldPosition(Theta,Phi,xr,yr,f,R,r0);


    counter_loop=counter_loop+1;

    
    %%%---------------------Move setup to new theta angel----------------------

end 

x %prints coordinates
y




