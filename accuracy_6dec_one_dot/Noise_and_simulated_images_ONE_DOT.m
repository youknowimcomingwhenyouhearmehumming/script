clear all;
close all;
clc;

% original = imread('Håndmålte billeder\b1.jpg');

% background=a;

original=imread('b80.3.tif');
figure(1)
imshow(original);
saveas(figure(1),'original.png')

red = original(:,:,1);
figure(2)
imshow(red);
saveas(figure(2),'red.png')


background_red=original(:,:,1);
% background_blue_green=original; 

[location_of_dot_y, location_of_dot_x] = locationDot_R_channel(red)
halflenght=20;
for i=(location_of_dot_x-20:location_of_dot_x+20)
    for j=(location_of_dot_y-20:location_of_dot_y+20)
    background_red(i,j)= background_red(i,j-200);   
    end
end





% figure(3)
% imshow(background_blue_green);
% saveas(figure(3),'background_blue_green.png')

figure(4)
imshow(background_red);
saveas(figure(4),'background_red.png')




Wsub = 40;
Hsub = 40;
[submatrix_red,offsetH_r,offsetW_r] = subMatrix(red,location_of_dot_y(1),location_of_dot_x(1),Wsub,Hsub)
figure(5)
imshow(submatrix_red);
saveas(figure(5),'submatrix_red.png')


% [submatrix_background_red,offsetH_b,offsetW_b] = subMatrix(background_red(:,:,1),900,1000,Wsub,Hsub)

% figure(6)
% hist_submatrix_background_red=histogram(submatrix_background_red)
% xlabel('Intensity') 
% ylabel('Counter') 
% title('Histogram for background noise submatrix 60x60 area') 
% saveas(figure(6),'Histogram for background noise submatrix 60x60 area.png')
% 
% 
% figure(7)
% hist_submatrix_red=histogram(submatrix_red)
% xlabel('Intensity') 
% ylabel('Counter') 
% title('Histogram for laser submatrix 60x60 area') 
% saveas(figure(7),'Histogram for laser submatrix 60x60 area.png')



%The next part is to estimates the noise
figure(8);
hist_background_red=histogram(background_red(:,:,1));
xlabel('Intensity'); 
ylabel('Counter') ;
title('Histogram for background noise full'); 
saveas(figure(8),'Histogram for background noise.png')

unique(background_red)



format long
total=sum(hist_background_red(1).Values(:));
parts=[];
parts(1)=hist_background_red(1).Values(1)/total;
parts(2)=hist_background_red(1).Values(2)/total;
parts(3)=hist_background_red(1).Values(3)/total;
parts(4)=hist_background_red(1).Values(4)/total;
parts(5)=hist_background_red(1).Values(5)/total;
parts(6)=hist_background_red(1).Values(6)/total;
parts(7)=hist_background_red(1).Values(7)/total;
parts(8)=hist_background_red(1).Values(8)/total;
parts(9)=hist_background_red(1).Values(9)/total;
parts(10)=hist_background_red(1).Values(10)/total;
parts(11)=hist_background_red(1).Values(11)/total;
parts(12)=hist_background_red(1).Values(12)/total;
parts(13)=hist_background_red(1).Values(13)/total;
parts(14)=hist_background_red(1).Values(14)/total;
parts(15)=hist_background_red(1).Values(15)/total;
parts(16)=hist_background_red(1).Values(16)/total;
parts(17)=hist_background_red(1).Values(17)/total;
parts(18)=hist_background_red(1).Values(18)/total;
parts(19)=hist_background_red(1).Values(19)/total;
parts(20)=hist_background_red(1).Values(20)/total;
parts(21)=hist_background_red(1).Values(21)/total;
parts(22)=hist_background_red(1).Values(22)/total;
parts(23)=hist_background_red(1).Values(23)/total;
parts(24)=hist_background_red(1).Values(24)/total;
parts(25)=hist_background_red(1).Values(25)/total;
parts(26)=hist_background_red(1).Values(26)/total;
parts(27)=hist_background_red(1).Values(27)/total;
parts(28)=hist_background_red(1).Values(28)/total;
parts(29)=hist_background_red(1).Values(29)/total;
parts(30)=hist_background_red(1).Values(30)/total;
parts(31)=hist_background_red(1).Values(31)/total;
parts(32)=hist_background_red(1).Values(32)/total;
parts(33)=hist_background_red(1).Values(33)/total;
parts(34)=hist_background_red(1).Values(34)/total;





%The next part is the gaussian fit
[h,w] = size(submatrix_red);
[X,Y] = meshgrid(1:w,1:h);
Z = submatrix_red;
[xD,yD,zD] = prepareSurfaceData(X,Y,Z);
figure(9); clf; scatter3(xD,yD,zD);
title('Scatter plot of laser dot','FontSize',20); 
xlabel('x coordinate','FontSize',15) 
ylabel('y coordinate','FontSize',15) 
zlabel('intensity value','FontSize',15) 
saveas(figure(9),'scatter.png')

% 2D gaussian fit object
gauss2 = fittype( @(b, a1, sigmax, sigmay, x0,y0, x, y) b+a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );
%Next 7 lines is guess parameters
a1 = max(submatrix_red(:)); % height, determine from image. may want to subtract background
sigmax = 6; % guess width
sigmay = 6; % guess width
[max_y,max_x] = find(submatrix_red == max(submatrix_red(:)));
x0 = max_x(1); % guess position as the maximum value
y0 = max_y(1);
b = mean(mean(background_red));
% compute fit
[fitresult, gof] = fit([xD,yD],zD,gauss2,'StartPoint',[b,a1, sigmax, sigmay, x0,y0]);
% plot(sf,[xD,yD],zD);
% Plot fit with data.
figure( 'Name', 'gauss_2d' );clf;
h = plot( fitresult, [xD, yD], zD );
legend( h, 'gauss_2d', 'submatrix_red vs. X, Y', 'Location', 'NorthEast' );
% Label axes
title('Scatter plot with the gaussion fit','FontSize',20); 
xlabel('x coordinate','FontSize',15) 
ylabel('y coordinate','FontSize',15) 
zlabel('intensity value','FontSize',15) 
grid on
Rmse = gof.rmse
saveas(figure(10),'Gauss.png')


 
simulated_pic_noise=[];
simulated_laser_dot_gauss=[];
for i = 1:10  % the i is how many simulated pictures you want
    i
    for j=1:Wsub+1
        for k=1:Hsub+1
            
            simulated_pic_noise(k,j)=noise(rand,parts);
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
saveas(figure(11),'simulated_pic_noise.png')
saveas(figure(12),'simulated_laser_dot_gauss.png')
saveas(figure(13),'simulated_pic_noise_and_laser.png')

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
    variantion_x_y(i,1)=middel_of_mass_simulated_images(i,1)/fitresult.y0; %Tjek om 1 hænger sammen med x0
    variantion_x_y(i,2)=middel_of_mass_simulated_images(i,2)/fitresult.x0;%Tjek om 2 hænger sammen med y0
end 



figure(14)
simulated_x_midofmass=histfit(middel_of_mass_simulated_images(:,2))
gauss_fit_vsimulated_x_midofmass= fitdist(middel_of_mass_simulated_images(:,2),'Normal')
% variation_in_y_gauss_in_pixels= gauss_fit_variation_in_y.sigma*fitresult.y0
xlabel('x pixel intensity value') 
ylabel('Counter') 
title('x coordinate for laser centers in simulated images') 
saveas(figure(14),'x center simulated images.png')


figure(15)
variation_in_x=histfit(variantion_x_y(:,2))
gauss_fit_variation_in_y= fitdist(variantion_x_y(:,2),'Normal')
variation_in_y_gauss_in_pixels= gauss_fit_variation_in_y.sigma*fitresult.y0
xlabel('relatively error between simulation and chosen x0 ') 
ylabel('Counter') 
title('Variation in x') 
saveas(figure(15),'Variation in x.png')


figure(16)
simulated_y_midofmass=histfit(middel_of_mass_simulated_images(:,1))
gauss_fit_vsimulated_y_midofmass= fitdist(middel_of_mass_simulated_images(:,1),'Normal')
% variation_in_y_gauss_in_piyels= gauss_fit_variation_in_y.sigma*fitresult.y0
xlabel('y pixel intensity value') 
ylabel('Counter') 
title('y coordinate for laser centers in simulated images') 
saveas(figure(16),'y center simulated images.png')


figure(17)
variation_in_y=histfit(variantion_x_y(:,1))
gauss_fit_variation_in_y= fitdist(variantion_x_y(:,1),'Normal')
variation_in_y_gauss_in_pixels= gauss_fit_variation_in_y.sigma*fitresult.y0
xlabel('relatively error between simulation and chosen y0 ') 
ylabel('Counter') 
title('Variation in y') 
saveas(figure(17),'Variation in y.png')


% 
% %-----------------------Poission simulated-------------------------------
% number_of_simulated_images_Poisson=10;
% lambdahat = poissfit(background_red(:)); %If hsv *1000000;
% simulated_images_Poisson=poissrnd(lambdahat, [Hsub+1,Wsub+1]);
% for i = 1:number_of_simulated_images_Poisson-1
%         i
%        simulated_images_Poisson=cat(3,simulated_images_Poisson,poissrnd(lambdahat, [Hsub+1,Wsub+1])); %if hsv ./1000000)
% end
% save simulated_images_Poisson.mat simulated_images_Poisson
% % temperary_name3=load('C:\Users\Bruger\Documents\Uni\Image analysis\Projekt\data_fra_simuleringer\simulated_images_Poisson.mat', 'simulated_images_Poisson');
% % simulated_images_Poisson=temperary_name3.simulated_images_Poisson(:,:,:);
% 
% figure(18)
% histogram(simulated_images_Poisson(:,:,1))
% xlabel('Intensity','FontSize',15) 
% ylabel('Counter','FontSize',15) 
% title('Background noise simulated as Poission','FontSize',20) 
% saveas(figure(18),'Background noise simulated as Poission.png')
% 
% 
% simulated_pic_noise=[];
% for i=1:1536*2304+1
%     simulated_pic_noise(i)=noise(rand,parts);;
% end
% figure(19)
% simu=histogram(simulated_pic_noise(:));
% xlabel('Intensity','FontSize',15) 
% ylabel('Counter','FontSize',15) 
% % title('Background noise simulated','FontSize',20) 
% % a = get(gca,'XTickLabel');
% % set(gca,'XTickLabel',a,'FontName','Times','fontsize',15)
% saveas(figure(19),'Background noise simulated directly.png')
% 

