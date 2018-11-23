% Let M be an image matrix with the a single gaussian spot (if you have lots of dots to fit gaussians in a single image you can pull them out by using bwlabel and regionprops Bounding box).

[h,w] = size(red);

[X,Y] = meshgrid(1:h,1:w);
X = X(:); Y=Y(:); Z = red(:);
figure(1); clf; scatter3(X,Y,Z);

% 2D gaussian fit object
gauss2 = fittype( @(a1, sigmax, sigmay, x0,y0, x, y) a1*exp(-(x-x0).^2/(2*sigmax^2)-(y-y0).^2/(2*sigmay^2)),...
'independent', {'x', 'y'},'dependent', 'z' );

a1 = max(red(:)); % height, determine from image. may want to subtract background
sigmax = 100; % guess width
sigmay = 100; % guess width
x0 = 990; % guess position (center seems a good place to start)
y0 = 590;

% compute fit
sf = fit([X,Y],double(Z),gauss2,'StartPoint',[a1, sigmax, sigmay, x0,y0]);
figure(6); clf; plot(sf,[X,Y],Z);

% sf.x0 and sf.y0 is the center of gaussian.
% sf.sigmax etc will get you the other parameters.

