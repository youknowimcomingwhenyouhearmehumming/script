


i = 0;
theta = 0;
theta0 = -80.8;
thetaStart = 13-theta0;
stepsize = -0.5;
while(1)
input('Press to image')
if indput==
end
image = snapshot(cam);
theta=thetaStart+stepsize*i;
name = ['delte' num2str(theta) '.tif'];
imwrite(image,name);
i = i+1;
end




