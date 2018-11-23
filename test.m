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

[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_green,offsetH_g,offsetW_g] = subMatrix(green,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
[submatrix_blue,offsetH_b,offsetW_b] = subMatrix(blue,location_of_dot_y,location_of_dot_x,Wsub,Hsub)


figure()
imshow(submatrix_red);
[midOfMass_H,midOfMass_W] = midOfMass(submatrix_red,Wsub,Hsub,offsetW_r,offsetH_r)

submatrixRGB = cat(3, submatrix_red, submatrix_green, submatrix_blue);
figure()
imshow(submatrixRGB);

figure()
imshow(submatrix_green);
[midOfMass_H,midOfMass_W] = midOfMass(submatrix_green,Wsub,Hsub,offsetW_g,offsetH_g)

figure()
imshow(submatrix_blue);
[midOfMass_H,midOfMass_W] = midOfMass(submatrix_blue,Wsub,Hsub,offsetW_b,offsetH_b)

xsums = sum(red,2);
ysums = sum(red,1);
figure()
edges = [ 1 1:1:256 256];
tt=histogram(xsums)

figure()
subplot(2,1,1)
histogram(xsums)
subplot(2,1,2)
histogram(ysums)








