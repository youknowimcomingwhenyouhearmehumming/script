function [X,Y,Z] = calcWorldPosition(Theta,Phi,xrr,yrr,f,R,r0)

% xr yr xl yl is all in image coordinates in mm. As seen on the image
% sensor with origo in the middle
%
%
%
%solved from book page 311

xr = -xrr;                      
yr = yrr;                       

xl = tan((Theta-90)*pi/180)*f; 
yl = -tan(Phi*pi/180)*f;

%solved from xr and yr eq:
%zr = f*(f*R(1,3)*r0(2)-f*r0(1)*R(2,3)+R(1,1)*r0(2)*xl+R(1,2)*r0(2)*yl-r0(1)*R(2,1)*xl-r0(1)*R(2,2)*yl)/(f*R(1,3)*yr-f*R(2,3)*xr+R(1,1)*xl*yr+R(1,2)*yl*yr-R(2,1)*xl*xr-R(2,2)*xr*yl);

%solved from xr and f eq:
zr = -f*(f*r0(1)*R(3,3)-f*r0(3)*R(1,3)+r0(1)*R(3,1)*xl+r0(1)*R(3,2)*yl-r0(3)*R(1,1)*xl-r0(3)*R(1,2)*yl)/(f^2*R(1,3)+f*R(1,1)*xl+f*R(1,2)*yl-f*R(3,3)*xr-R(3,1)*xl*xr-R(3,2)*xr*yl)

%with zr found the rest is just scaling up:
X = xr/f*zr;
Y = yr/f*zr;
Z = zr;
end

