clear all;
close all;
clc;

% original = imread('Håndmålte billeder\b1.jpg');

a = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_0.4_set1_thor.jpg');
b = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_off_set1_thor.jpg');
c = imread('Filtter billeder\Laser_on_Light_off_650mn_on_nd_0.4set1_thor.jpg');
d = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg');
e = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_off_set1_thor.jpg');
original=d;
background=a;

figure(1)
imshow(original);
red = original(:,:,1);
figure(2)
imshow(red);


[location_of_dot_x, location_of_dot_y] = locationDot_R_channel(red)

Wsub = 30;
Hsub = 20;
[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
figure()
imshow(submatrix_red);

[submatrix_background_red,offsetH_b,offsetW_b] = subMatrix(background(:,:,1),location_of_dot_y,location_of_dot_x,Wsub,Hsub)



figure()
hist_background_red=histogram(background(:,:,1))
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for background noise full') 

figure()
hist_submatrix_background_red=histogram(submatrix_background_red)
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for background noise submatrix 21x31 area') 

figure()
hist_submatrix_red=histogram(submatrix_red)
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for laser submatrix 21x31 area') 


total=sum(hist_background_red(1).Values(:))
part_of_1=hist_background_red(1).Values(1)/total
part_of_2=hist_background_red(1).Values(2)/total
part_of_3=hist_background_red(1).Values(3)/total
part_of_4=hist_background_red(1).Values(4)/total
part_of_5=hist_background_red(1).Values(5)/total
part_of_6=hist_background_red(1).Values(6)/total




 
simulated_pic_noise=[];
for i = 1:10
    for j=1:Wsub
        for k=1:Hsub
            simulated_pic_noise(k,j)=noise(rand);
        end
    end 
    if i==1
        simulated_pictures_noise=simulated_pic_noise
    end
    if i<=1
    simulated_pictures_noise=cat(3,simulated_pictures_noise,simulated_pic_noise_new
    end
end



%-----------------------Poission simulated-------------------------------
number_of_simulated_images_Poisson=10;
lambdahat = poissfit(submatrix_background_red(:)); %If hsv *1000000;
simulated_images_Poisson=poissrnd(lambdahat, [Hsub+1,Wsub+1]);
for i = 1:number_of_simulated_images_Poisson-1
       simulated_images_Poisson=cat(3,simulated_images_Poisson,poissrnd(lambdahat, [Hsub+1,Wsub+1])); %if hsv ./1000000)
end
figure()
histogram(simulated_images_Poisson(:,:,1))
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for picture with background noise simulated as Poission with') 



function [noise] = noise(rnd)
if rnd>=part_of_1
    noise=1
end
if rnd>=part_of_1+part_of_2
    noise=2
end
if rnd>=part_of_1+part_of_2+part_of_3
    noise=3
    end
if rnd>=part_of_1+part_of_2+part_of_3+part_of_4
    noise=4
    end
if rnd>=part_of_1+part_of_2+part_of_3+part_of_4+part_of_5
    noise=5
    end

if rnd>=part_of_1+part_of_2+part_of_3+part_of_4++part_of_5++part_of_6
    noise=6
    end
end


