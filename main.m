clear all;
close all;
clc;

original = imread('Håndmålte billeder\b1.jpg');
figure()
imshow(original);
red = original(:,:,1);
green=original(:,:,2);
blue=original(:,:,3);

figure()
imshow(red);


[location_of_dot_x, location_of_dot_y] = locationDot(original) ;

Wsub = 30;
Hsub = 20;

[submatrix_red,offsetH,offsetW] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_green,offsetH,offsetW] = subMatrix(green,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_blue,offsetH,offsetW] = subMatrix(blue,location_of_dot_y,location_of_dot_x,Wsub,Hsub)


figure()
imshow(submatrix_red);

submatrixRGB = cat(3, submatrix_red, submatrix_green, submatrix_blue);
figure()
imshow(submatrixRGB);

[midOfMass_H,midOfMass_W] = midOfMass(submatrix_red,Wsub,Hsub,offsetW,offsetH)











