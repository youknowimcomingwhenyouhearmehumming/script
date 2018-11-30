clear all;
close all;
clc;


% original = imread('H�ndm�lte billeder\b1.jpg');

a = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_0.4_set1_thor.jpg');
b = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_off_set1_thor.jpg');
c = imread('Filtter billeder\Laser_on_Light_off_650mn_on_nd_0.4set1_thor.jpg');
d = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg');
e = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_off_set1_thor.jpg');
original=d;

figure(1)
imshow(original);
red = original(:,:,1);

figure(2)
imshow(red);


[location_of_dot_y, location_of_dot_x] = locationDot_R_channel(original);


Wsub = 30;
Hsub = 20;

[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub);

figure()
imshow(submatrix_red);


% Let M be an image matrix with the a single gaussian spot (if you have lots of dots to fit gaussians in a single image you can pull them out by using bwlabel and regionprops Bounding box).

[h,w] = size(submatrix_red);

[X,Y] = meshgrid(1:w,1:h);

Z = submatrix_red;


[xD,yD,zD] = prepareSurfaceData(X,Y,Z);
figure(); clf; scatter3(xD,yD,zD);

% 2D gaussian fit object
gauss2 = fittype( @(b, a1, sigmax, sigmay, x0,y0, x, y) b+a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );

a1 = max(submatrix_red(:)); % height, determine from image. may want to subtract background
sigmax = 3; % guess width
sigmay = 3; % guess width
[max_y,max_x] = find(submatrix_red == max(submatrix_red(:)));

x0 = max_x(1); % guess position as the maximum value
y0 = max_y(1);
b = 3.8171;


% compute fit
[fitresult, gof] = fit([xD,yD],zD,gauss2,'StartPoint',[b,a1, sigmax, sigmay, x0,y0]);
% plot(sf,[xD,yD],zD);


% Plot fit with data.
figure( 'Name', 'gauss_2d' );clf;
h = plot( fitresult, [xD, yD], zD );
legend( h, 'gauss_2d', 'submatrix_red vs. X, Y', 'Location', 'NorthEast' );
% Label axes
xlabel X
ylabel Y
zlabel 'Intensity'
grid on

Rmse = gof.rmse

%sf.x0
%sf.y0
%sf.sigmax
%sf.sigmay
% sf.x0 and sf.y0 is the center of gaussian.
% sf.sigmax etc will get you the other parameters.



fitresult.b+fitresult.a1*exp(-(16-fitresult.x0).^2/(2*fitresult.sigmax^2)-(11-fitresult.y0).^2/(2*fitresult.sigmay^2))
