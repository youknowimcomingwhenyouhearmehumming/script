function [midOfMass_H,midOfMass_W,rms] = midOfMass_gauss(submatrix,offsetW,offsetH)
%SUBsubmatrix Author=Rasmus. The meaning of the function is to determinate the
%middel of the mass of the laser dot based on the subsubmatrix that is
%loaded into the funktion. NOTE!!! that it  calculated the middel of all
%the pixel in the submatrix, so unless that some threshold is added then
%this calculation will be slightly wrong. 
%The outout of the funtion is the mddel of the mass in the height and in
%the width direction
%   Detailed explanation goes here


% Let M be an image matrix with the a single gaussian spot (if you have lots of dots to fit gaussians in a single image you can pull them out by using bwlabel and regionprops Bounding box).

[h,w] = size(submatrix);

[X,Y] = meshgrid(1:w,1:h);

Z = submatrix;

[xD,yD,zD] = prepareSurfaceData(X,Y,Z);
%Next one line is only for plot
% figure(); clf; scatter3(xD,yD,zD);

% 2D gaussian fit object
gauss2 = fittype( @(b, a1, sigmax, sigmay, x0,y0, x, y) b+a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );

%Next 7 lines is guess parameters
a1 = max(submatrix(:)); % height, determine from image. may want to subtract background
sigmax = 3; % guess width
sigmay = 3; % guess width
[max_y,max_x] = find(submatrix == max(submatrix(:)));
x0 = max_x(1); % guess position as the maximum value
y0 = max_y(1);
b = 3.8171;


% compute fit
[fitresult, gof] = fit([xD,yD],zD,gauss2,'StartPoint',[b,a1, sigmax, sigmay, x0,y0]);
% plot(sf,[xD,yD],zD);


midOfMass_H =fitresult.y0+ offsetH;
midOfMass_W=fitresult.x0 + offsetW;
rms = gof.rmse;


% % Next lines is only or plot
%Plot fit with data.
% figure( 'Name', 'gauss_2d' );clf;
% h = plot( fitresult, [xD, yD], zD );
% legend( h, 'gauss_2d', 'submatrix vs. X, Y', 'Location', 'NorthEast' );
% % Label axes
% xlabel X
% ylabel Y
% zlabel 'Intensity'
% grid on




% fitresult.b+fitresult.a1*exp(-(16-fitresult.x0).^2/(2*fitresult.sigmax^2)-(11-fitresult.y0).^2/(2*fitresult.sigmay^2))




end

