


i = 0;
theta = 0;
theta0 = -80.8;
thetaStart = 13-theta0;
stepsize = -0.5;
while(1)
input('Press to image')

image = snapshot(cam);
theta=thetaStart+stepsize*i;
% name = ['b' num2str(theta) '.tif'];
name=['kalibrering_6_dec' num2str(i) '.tif'];
imwrite(image,name);
i = i+1;
end




