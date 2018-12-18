clear all;
close all;
clc;

% original = imread('Håndmålte billeder\b1.jpg');

% background=a;

% original=imread('img_dec14_secondscanmosquito78.0014.tif');
% 
% background_red=original(:,:,1);
% 
% for i=(403:1048)
%     for j=(1298:1345)
%     background_red(i,j)= background_red(i,j-200);   
%     end
% end


original=imread('img_dec14_laser_off.tif');

background_red=original(:,:,1);




red = original(:,:,1);
figure(2)
imshow(red);
saveas(figure(2),'red.png')


figure(4)
imshow(background_red);
saveas(figure(4),'background_red.png')



[location_of_dot_y, location_of_dot_x] = locationDot_R_channel(red)

Wsub = 30;
Hsub = 30;
% [submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y(2),location_of_dot_x(2),Wsub,Hsub)
% figure(5)
% imshow(submatrix_red);
% saveas(figure(5),'submatrix_red.png')


figure(8);
hist_background_red=histogram(background_red(:,:,1));
xlabel('Intensity'); 
ylabel('Counter') ;
title('Histogram for background noise full'); 
saveas(figure(8),'Histogram for background noise.png')
