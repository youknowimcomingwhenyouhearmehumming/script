function [R,r0] = externalCalibration(images,worldCoordinatesXYZ,angles)
%EXTERNALCALIBRATION Summary of this function goes here
%   Detailed explanation goes here
%worldcoordinates are:  [X1 X2 X3]
%                       [Y1 Y2 Y3]
%                       [Z1 Z2 Z3]
%angles = [Theta1 Theta2 Theta3;Phi1 Phi2 Phi3]

image1 = images(1);
image2 = images(2);
image3 = images(3);

xr1 = worldCoordinatesXYZ(1,1);
yr1 = worldCoordinatesXYZ(2,1);
zr1 = worldCoordinatesXYZ(3,1);
xl1 = ;
yl1 = ;
zl1 = ;

xr2 = worldCoordinatesXYZ(1,2);
yr2 = worldCoordinatesXYZ(2,2);
zr2 = worldCoordinatesXYZ(3,2);
xl2 = ;
yl2 = ;
zl2 = ;

xr3 = worldCoordinatesXYZ(1,3);
yr3 = worldCoordinatesXYZ(2,3);
zr3 = worldCoordinatesXYZ(3,3);
xl3 = ;
yl3 = ;
zl3 = ;


end

