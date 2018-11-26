clear all;
close all;
clc;


original = imread('Håndmålte billeder\b1.jpg');

a = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_0.4_set1_thor.jpg');
b = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_off_set1_thor.jpg');
c = imread('Filtter billeder\Laser_on_Light_off_650mn_on_nd_0.4set1_thor.jpg');
d = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg');
e = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_off_set1_thor.jpg');
original=d;

figure()
imshow(original);
red = original(:,:,1);
green=original(:,:,2);
blue=original(:,:,3);

figure()
imshow(red);


[location_of_dot_x, location_of_dot_y] = locationDot(original);

%since lication doesnøt find the middel but the upper coerne the next two
%lines is a simpel adjustedment for that
location_of_dot_x=location_of_dot_x+2;
location_of_dot_y+2;


Wsub = 30;
Hsub = 20;

[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_green,offsetH_g,offsetW_g] = subMatrix(green,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_blue,offsetH_b,offsetW_b] = subMatrix(blue,location_of_dot_y,location_of_dot_x,Wsub,Hsub)

hsv = rgb2hsv(original);
[submatrix_hsv,offsetH_b,offsetW_b] = subMatrix(hsv(:,:,3),location_of_dot_y,location_of_dot_x,Wsub,Hsub)
% 
figure()
imshow(submatrix_red);


mask=[submatrix_hsv>=0.05 ] ;
hsv_cut=mask.*submatrix_hsv;

figure()
imshow(hsv_cut);



[midOfMass_H,midOfMass_W] = midOfMass(hsv_cut,Wsub,Hsub,offsetW_r,offsetH_r)



[submatrix_hsv_final,offsetH_b,offsetW_b] = subMatrix(hsv(:,:,3),midOfMass_W,midOfMass_H,Wsub,Hsub)

mask=[submatrix_hsv_final>=0.04 ] ;
submatrix_hsv_final_cut=mask.*submatrix_hsv_final;

figure()
imshow(submatrix_hsv_final_cut);

% submatrixRGB = cat(3, submatrix_red, submatrix_green, submatrix_blue);
% figure()
% imshow(submatrixRGB);

% figure()
% imshow(submatrix_green);
% [midOfMass_H,midOfMass_W] = midOfMass(submatrix_green,Wsub,Hsub,offsetW_g,offsetH_g)
% 
% figure()
% imshow(submatrix_blue);
% [midOfMass_H,midOfMass_W] = midOfMass(submatrix_blue,Wsub,Hsub,offsetW_b,offsetH_b)



% Let M be an image matrix with the a single gaussian spot (if you have lots of dots to fit gaussians in a single image you can pull them out by using bwlabel and regionprops Bounding box).

[h,w] = size(submatrix_hsv_final_cut);

[X,Y] = meshgrid(1:h,1:w);
X = X(:); Y=Y(:); Z = submatrix_hsv_final_cut(:);
figure(); clf; scatter3(X,Y,Z);

% 2D gaussian fit object
gauss2 = fittype( @(a1, sigmax, sigmay, x0,y0, x, y) a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );

a1 = max(submatrix_hsv_final_cut(:)); % height, determine from image. may want to subtract background
sigmax = 3; % guess width
sigmay = 3; % guess width
x0 = 15; % guess position (center seems a good place to start)
y0 = 10;

% compute fit
sf = fit([X,Y],double(Z),gauss2,'StartPoint',[a1, sigmax, sigmay, x0,y0]);
figure(); clf; plot(sf,[X,Y],Z);

% sf.x0 and sf.y0 is the center of gaussian.
% sf.sigmax etc will get you the other parameters.

