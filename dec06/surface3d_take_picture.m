
input('Press to image')

image = snapshot(cam);
% name = ['b' num2str(theta) '.tif'];
% name=['kalibrering_6_dec' num2str(i) '.tif'];
name=['filter_off_laser_off_light_off.tif'];

imwrite(image,name);
i = i+1;





