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


Wsub = 30;
Hsub = 20;

[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_green,offsetH_g,offsetW_g] = subMatrix(green,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_blue,offsetH_b,offsetW_b] = subMatrix(blue,location_of_dot_y,location_of_dot_x,Wsub,Hsub)

hsv = rgb2hsv(original);
[submatrix_hsv,offsetH_b,offsetW_b] = subMatrix(hsv(:,:,3),location_of_dot_y,location_of_dot_x,Wsub,Hsub)
% 
figure(7)
imshow(submatrix_red);


mask=[submatrix_hsv>=0.05 ] ;
hsv_cut=mask.*submatrix_hsv;

figure(8)
imshow(hsv_cut);



[midOfMass_H,midOfMass_W] = midOfMass(hsv_cut,Wsub,Hsub,offsetW_r,offsetH_r)

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













