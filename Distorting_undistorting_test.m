
sensor_pixW = 2.2*10e-3;%in mm. has to be found precicely
sensor_pixH = 2.2*10e-3;;%in mm. has to be found precicely
%f_focal = (intrinsicMatrix(1,1)*sensor_pixW+intrinsicMatrix(2,2)*sensor_pixH)/2; %the mean of the calculatet f from y and x magnification

f_in_pix_x = cameraParams.IntrinsicMatrix(1,1);
f_in_pix_y = cameraParams.IntrinsicMatrix(2,2);

%Undistorted points
x = [0:0.1:2];
y = [0:0.1:2];
[X,Y] = meshgrid(x,y);
X = (X-1)*1920/f_in_pix_x;
Y = (Y-1)*1080/f_in_pix_y;


%%%%%%%%%%
k1 = cameraParams.RadialDistortion(1,1);
k2 = cameraParams.RadialDistortion(1,2);
p1 = cameraParams.TangentialDistortion(1,1);
p2 = cameraParams.TangentialDistortion(1,2);
r = sqrt(X.^2+Y.^2);

%
Xd1 = X.*(k2*r.^4+k1*r.^2+1)+2*p1.*X.*Y+p2*(r.^2+2*X.^2);
Yd1 = Y.*(k2*r.^4+k1*r.^2+1)+2*p2.*X.*Y+p1*(r.^2+2*Y.^2);
%%%%%%%%%%

figure(2)
subplot(2,2,1)
plot(X,Y,'.','color','b')
hold on
plot(0,0,'o','color','r')
title('Undistorted image points')
subplot(2,2,2)
plot(Xd1,Yd1,'.','color','b')
hold on
plot(0,0,'o','color','r')
title('distorted')

subplot(2,2,3)
plot(X*f_in_pix_x,Y*f_in_pix_y,'.','color','b')
hold on
plot(0,0,'o','color','r')
title('distorted')
subplot(2,2,4)
plot(Xd1*f_in_pix_x,Yd1*f_in_pix_y,'.','color','b')
hold on
plot(0,0,'o','color','r')
title('distorted')

%%
%Now we need to prove that we can undistort an image using the distorted
%image and the coefficients.
%



