function [midOfMass_H,midOfMass_W] = midOfMass_gauss(submatrix,Wsub,Hsub,offsetW,offsetH)
%SUBsubmatrix Author=Rasmus. The meaning of the function is to determinate the
%middel of the mass of the laser dot based on the subsubmatrix that is
%loaded into the funktion. NOTE!!! that it  calculated the middel of all
%the pixel in the submatrix, so unless that some threshold is added then
%this calculation will be slightly wrong. 
%The outout of the funtion is the mddel of the mass in the height and in
%the width direction
%   Detailed explanation goes here

xsums = sum(submatrix,2);
ysums = sum(submatrix,1);
% figure()
% subplot(2,1,1)
% bar(1:Wsub+1,ysums)
% subplot(2,1,2)
% bar(1:Hsub+1,xsums)
SUM = sum(xsums);
midOfMass_H = (sum(([1:Hsub+1]'.*xsums)')/SUM) + offsetH
midOfMass_W = (sum(([1:Wsub+1].*ysums))/SUM) + offsetW



% Let M be an image matrix with the a single gaussian spot (if you have lots of dots to fit gaussians in a single image you can pull them out by using bwlabel and regionprops Bounding box).

[h,w] = size(submatrix_red);

[X,Y] = meshgrid(1:w,1:h);

Z = submatrix_red;


[xD,yD,zD] = prepareSurfaceData(X,Y,Z);
figure(); clf; scatter3(xD,yD,zD);

% 2D gaussian fit object
gauss2 = fittype( @(b, a1, sigmax, sigmay, x0,y0, x, y) b+a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );

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

%sf.x0
%sf.y0
%sf.sigmax
%sf.sigmay
% sf.x0 and sf.y0 is the center of gaussian.
% sf.sigmax etc will get you the other parameters.



fitresult.b+fitresult.a1*exp(-(16-fitresult.x0).^2/(2*fitresult.sigmax^2)-(11-fitresult.y0).^2/(2*fitresult.sigmay^2))




end

