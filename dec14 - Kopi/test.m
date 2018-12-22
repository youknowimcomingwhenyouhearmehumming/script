

cam=webcam('c922')

input('Press to image')

image = snapshot(cam);
% name = ['bfirstscanmosquito' num2str(theta) '.tif'];
% name=['img_dec14_fourthposgreenlaser' num2str(theta) '.tif'];
name=['no_filter_laser_off_use_this.tif'];

imwrite(image,name);

