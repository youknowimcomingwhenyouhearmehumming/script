clear all;
close all;
clc;

% original = imread('Håndmålte billeder\b1.jpg');

a = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_0.4_set1_thor.jpg');
b = imread('Filtter billeder\Laser_off_Light_on_650mn_on_nd_off_set1_thor.jpg');
c = imread('Filtter billeder\Laser_on_Light_off_650mn_on_nd_0.4set1_thor.jpg');
d = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_0.4set1_thor.jpg');
e = imread('Filtter billeder\Laser_on_Light_on_650mn_on_nd_off_set1_thor.jpg');
% original=d;
% background=a;

original=imread('High_res_Laser_on_Light_on_650mn_on_nd_0.4.tif');
background=original; 

figure(1)
imshow(original);
saveas(figure(1),'original.png')

red = original(:,:,1);
figure(2)
imshow(red);
saveas(figure(2),'red.png')



[location_of_dot_y, location_of_dot_x] = locationDot_R_channel(red)

Wsub = 60;
Hsub = 60;
[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y(1),location_of_dot_x(1),Wsub,Hsub)
figure(3)
imshow(submatrix_red);
saveas(figure(3),'submatrix_red.png')


[submatrix_background_red,offsetH_b,offsetW_b] = subMatrix(background(:,:,1),900,1000,Wsub,Hsub)

figure(4)
hist_submatrix_background_red=histogram(submatrix_background_red)
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for background noise submatrix 60x60 area') 
saveas(figure(4),'Histogram for background noise submatrix 60x60 area.png')


figure(5)
hist_submatrix_red=histogram(submatrix_red)
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for laser submatrix 60x60 area') 
saveas(figure(5),'Histogram for laser submatrix 60x60 area.png')



%The next part is to estimates the noise
figure(6);
hist_background_red=histogram(background(:,:,1));
xlabel('Intensity'); 
ylabel('Counter') ;
title('Histogram for background noise full'); 
saveas(figure(6),'Histogram for background noise.png')

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
figure(7); clf; scatter3(xD,yD,zD);
saveas(figure(7),'scatter.png')

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
saveas(figure(8),'Gauss.png')

 
simulated_pic_noise=[];
simulated_laser_dot_gauss=[];
for i = 1:10
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

% The next line saved the simulated images
save simulated_pic_noise_and_laser.mat simulated_pic_noise_and_laser
% temperary_name=load('C:\Users\Bruger\Documents\Uni\Image analysis\Projekt\data_fra_simuleringer\simulated_pic_noise_and_laser.mat', 'simulated_pic_noise_and_laser');
% simulated_pic_noise_and_laser=temperary_name.simulated_pic_noise_and_laser(:,:,:);

show_image_nicely(simulated_pic_noise);
show_image_nicely(simulated_laser_dot_gauss);
show_image_nicely(simulated_pic_noise_and_laser(:,:,1)); %Showing just the first of the many simulated images
saveas(figure(9),'simulated_pic_noise.png')
saveas(figure(10),'simulated_laser_dot_gauss.png')
saveas(figure(11),'simulated_pic_noise_and_laser.png')

%Finding the middel of mass of the simulated images:
middel_of_mass_simulated_images=zeros(size(simulated_pic_noise_and_laser,3),3); %The tre dimension is midOfMass_H,midOfMass_W,rms
for i = 1:size(simulated_pic_noise_and_laser,3)
    i
    [middel_of_mass_simulated_images(i,1),middel_of_mass_simulated_images(i,2),middel_of_mass_simulated_images(i,3)] = midOfMass_gauss(simulated_pic_noise_and_laser(:,:,i),0,0);

end 

%Delete next line when running for all pctires
% middel_of_mass_simulated_images=middel_of_mass_simulated_images(1:5000,:);

% The next line saved the middel of mass for the simulated images
save middel_of_mass_simulated_images.mat middel_of_mass_simulated_images
% temperary_name2=load('C:\Users\Bruger\Documents\Uni\Image analysis\Projekt\data_fra_simuleringer\middel_of_mass_simulated_images.DAT', 'middel_of_mass_simulated_images');
% middel_of_mass_simulated_images=temperary_name2.middel_of_mass_simulated_images(:,:,:);

 %Her findes variationen ift. til de oprindelige gauss simuleret middel punkter 
 variantion_x_y=zeros(size(middel_of_mass_simulated_images,1),2);
for i = 1:size(middel_of_mass_simulated_images,1)
    variantion_x_y(i,1)=middel_of_mass_simulated_images(i,1)/fitresult.x0; %Tjek om 1 hænger sammen med x0
    variantion_x_y(i,2)=middel_of_mass_simulated_images(i,2)/fitresult.y0;%Tjek om 2 hænger sammen med y0
end 

figure(12)
variation_in_x=histogram(variantion_x_y(:,1))
gauss_fit_variation_in_x= fitdist(variantion_x_y(:,1),'Normal')
variation_in_x_gauss_in_pixels= gauss_fit_variation_in_x.sigma*fitresult.x0
xlabel('relatively error between simulation and chosen x0 ') 
ylabel('Counter') 
title('Variation in x') 
saveas(figure(12),'Variation in x.png')


figure(13)
variation_in_y=histfit(variantion_x_y(:,2))
gauss_fit_variation_in_y= fitdist(variantion_x_y(:,2),'Normal')
variation_in_y_gauss_in_pixels= gauss_fit_variation_in_y.sigma*fitresult.y0
ylabel('Counter') 
xlabel('relatively error between simulation and chosen y0') 
title('Variation in y') 
saveas(figure(13),'Variation in y.png')




%-----------------------Poission simulated-------------------------------
number_of_simulated_images_Poisson=10;
lambdahat = poissfit(submatrix_background_red(:)); %If hsv *1000000;
simulated_images_Poisson=poissrnd(lambdahat, [Hsub+1,Wsub+1]);
for i = 1:number_of_simulated_images_Poisson-1
        i
       simulated_images_Poisson=cat(3,simulated_images_Poisson,poissrnd(lambdahat, [Hsub+1,Wsub+1])); %if hsv ./1000000)
end
save simulated_images_Poisson.mat simulated_images_Poisson
% temperary_name3=load('C:\Users\Bruger\Documents\Uni\Image analysis\Projekt\data_fra_simuleringer\simulated_images_Poisson.mat', 'simulated_images_Poisson');
% simulated_images_Poisson=temperary_name3.simulated_images_Poisson(:,:,:);

figure()
histogram(simulated_images_Poisson(:,:,1))
xlabel('Intensity') 
ylabel('Counter') 
title('Histogram for picture with background noise simulated as Poission') 
saveas(figure(14),'Histogram for picture with background noise simulated as Poission.png')


