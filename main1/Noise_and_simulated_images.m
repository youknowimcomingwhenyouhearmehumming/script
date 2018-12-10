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


[location_of_dot_y, location_of_dot_x] = locationDot_R_channel(red)

Wsub = 30;
Hsub = 20;
[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y,location_of_dot_x,Wsub,Hsub)
figure()
imshow(submatrix_red);

[submatrix_background_red,offsetH_b,offsetW_b] = subMatrix(background(:,:,1),location_of_dot_y,location_of_dot_x,Wsub,Hsub)

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



%The next part is to estimates the noise
a = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_0.4_set1_thor.jpg');
background=a;
figure();
hist_background_red=histogram(background(:,:,1));
xlabel('Intensity'); 
ylabel('Counter') ;
title('Histogram for background noise full'); 
total=sum(hist_background_red(1).Values(:));
part_of_1=hist_background_red(1).Values(1)/total;
part_of_2=hist_background_red(1).Values(2)/total;
part_of_3=hist_background_red(1).Values(3)/total;
part_of_4=hist_background_red(1).Values(4)/total;
part_of_5=hist_background_red(1).Values(5)/total;
part_of_6=hist_background_red(1).Values(6)/total;


%The next part is the gaussian fit
[h,w] = size(submatrix_red);
[X,Y] = meshgrid(1:w,1:h);
Z = submatrix_red;
[xD,yD,zD] = prepareSurfaceData(X,Y,Z);
figure(); clf; scatter3(xD,yD,zD);
% 2D gaussian fit object
gauss2 = fittype( @(b, a1, sigmax, sigmay, x0,y0, x, y) b+a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );
%Next 7 lines is guess parameters
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

 
simulated_pic_noise=[];
simulated_laser_dot_gauss=[];
for i = 1:100
    i
    for j=1:Wsub+1
        for k=1:Hsub+1
            
            simulated_pic_noise(k,j)=noise(rand,part_of_1,part_of_2,part_of_3,part_of_4,part_of_5,part_of_6);
            simulated_laser_dot_gauss(k,j)=fitresult.a1*exp(-(j-fitresult.x0).^2/(2*fitresult.sigmax^2)-(k-fitresult.y0).^2/(2*fitresult.sigmay^2));
            %I laser_dot_gauss er b-værdien ikke med, da dette netop er
            %baggrundsstrålingen, og denne kommer fra pic_noise, så hvis
            %b-værdien var med ville baggrunden være dobbelt
        end
    end
    %The next line is just for setting the pictures togehter as one data
    %structure
    if i==1
        simulated_pic_noise_and_laser=simulated_pic_noise+simulated_laser_dot_gauss;
    end
    if i>1
    simulated_pic_noise_and_laser=cat(3,simulated_pic_noise_and_laser,simulated_pic_noise+simulated_laser_dot_gauss);
    end     
end
    
show_image_nicely(simulated_pic_noise);
show_image_nicely(simulated_laser_dot_gauss);
show_image_nicely(simulated_pic_noise_and_laser(:,:,1)); %Showing just the first of the many simulated images

%Finding the middel of mass of the simulated images:
results=zeros(size(simulated_pic_noise_and_laser,3),3); %The tre dimension is midOfMass_H,midOfMass_W,rms
for i = 1:size(simulated_pic_noise_and_laser,3)
    [results(i,1),results(i,2),results(i,3)] = midOfMass_gauss(simulated_pic_noise_and_laser(:,:,i),0,0);

end 



%% 
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


