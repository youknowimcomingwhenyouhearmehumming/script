function [X,Y,Z] = calcWorldPosition(Theta,Phi,xr,yr,f,R,r0)
%CALCWORLDPOSITION Summary of this function goes here
%   Detailed explanation goes here
% xr yr xl yl is all in image coordinates. make shure to use same units.
%
%How to apply R and r0: 
%solved from book page 311


xl = -tan((90-Theta)*pi/180)*f;
yl = -tan((Phi)*pi/180)*f;
zr = f*(f*R(1,3)*r0(3)-f*r0(1)*R(3,3)+R(1,1)*r0(3)*xl+R(1,2)*r0(3)*yl-r0(1)*R(3,1)*xl-r0(1)*R(3,2)*yl)/(f^2*R(1,3)+f*R(1,1)*xl+f*R(1,2)*yl-f*R(3,3)*xr-R(3,1)*xl*xr-R(3,2)*xr*yl);

%with zr found the rest is just scaling up:
X = xr/f*zr;
Y = yr/f*zr;
Z = zr;
end

