function [X_measured,Y_measured,Z_measured,baseline_measured,Theta_measured,Phi_measured] = getMeasurements()

%%Measurement point from 03-12
camera_y = 199;
laser_y = 199;
Theta_off = 12.6-90;

baseline_measured = 250;

X_measured = [-250;0;200;400;0;-500;-250];
Y_measured = [191;190;189.2;189;195;188;8]-camera_y;
Z_measured = [-1367;-1367;-1367;-1367;-917;-1367;-1367];

Theta_measured = [12.6;-2.18;-5.75;-13;-3.55;22.93;12.6]-Theta_off;
%We cheat a bit with Phi by using the coordinates to get the angle
Phi_measured = atan(Y_measured./sqrt(Z_measured.^2+X_measured.^2))*180/pi;
end