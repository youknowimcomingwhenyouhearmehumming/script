function errors = objective(x,laser_points,camera_points,f,baseLineLength)
%OBJECTIVE Summary of this function goes here
%   Detailed explanation goes here
%
%laser and image points are 5x2 matrix with [xi,yi] in each row.
%
%laser and camerapoints are where the dot would be seen on the image sensor
%f away from the pinhole. therefor if realworld X is positive to camera the
%camera point x would be negative.
%
%x = [r11, r12, r13, r14, r21, r22, r23, r24, r31, r32, r33, r34, zl1,
%zl2, zl3, zl4, zl5, zr1, zr2, zr3, zr4, zr5]
orthonormalityWeight = 1000;

x = x';
r11 = x(1,1);
r12 = x(1,2);
r13 = x(1,3);
r14 = x(1,4);
r21 = x(1,5);
r22 = x(1,6);
r23 = x(1,7);
r24 = x(1,8);
r31 = x(1,9);
r32 = x(1,10);
r33 = x(1,11);
r34 = x(1,12);
zl1 = x(1,13);
zl2 = x(1,14);
zl3 = x(1,15);
zl4 = x(1,16);
zl5 = x(1,17);
zr1 = x(1,18);
zr2 = x(1,19);
zr3 = x(1,20);
zr4 = x(1,21);
zr5 = x(1,22);
%%
xl1 = laser_points(1,1);
xl2 = laser_points(2,1);
xl3 = laser_points(3,1);
xl4 = laser_points(4,1);
xl5 = laser_points(5,1);

yl1 = laser_points(1,2);
yl2 = laser_points(2,2);
yl3 = laser_points(3,2);
yl4 = laser_points(4,2);
yl5 = laser_points(5,2);

xr1 = camera_points(1,1);
xr2 = camera_points(2,1);
xr3 = camera_points(3,1);
xr4 = camera_points(4,1);
xr5 = camera_points(5,1);

yr1 = camera_points(1,2);
yr2 = camera_points(2,2);
yr3 = camera_points(3,2);
yr4 = camera_points(4,2);
yr5 = camera_points(5,2);

%%

%%
errors = zeros(22,1);

errors(1) = (r11*xl1+r12*yl1+r13*f+r14*f/zl1 - (xr1*zr1/zl1))^2;
errors(2) = (r21*xl1+r22*yl1+r23*f+r24*f/zl1 - (yr1*zr1/zl1))^2;
errors(3) = (r31*xl1+r32*yl1+r33*f+r34*f/zl1 - (f*zr1/zl1))^2;

errors(4) = (r11*xl2+r12*yl2+r13*f+r14*f/zl2 - xr2*zr2/zl2)^2;
errors(5) = (r21*xl2+r22*yl2+r23*f+r24*f/zl2 - yr2*zr2/zl2)^2;
errors(6) = (r31*xl2+r32*yl2+r33*f+r34*f/zl2 - f*zr2/zl2)^2;
errors(7) = (r11*xl3+r12*yl3+r13*f+r14*f/zl3 - xr3*zr3/zl3)^2;
errors(8) = (r21*xl3+r22*yl3+r23*f+r24*f/zl3 - yr3*zr3/zl3)^2;
errors(9) = (r31*xl3+r32*yl3+r33*f+r34*f/zl3 - f*zr3/zl3)^2;
errors(10) = (r11*xl4+r12*yl4+r13*f+r14*f/zl4 - xr4*zr4/zl4)^2;
errors(11) = (r21*xl4+r22*yl4+r23*f+r24*f/zl4 - yr4*zr4/zl4)^2;
errors(12) = (r31*xl4+r32*yl4+r33*f+r34*f/zl4 - f*zr4/zl4)^2;
errors(13) = (r11*xl5+r12*yl5+r13*f+r14*f/zl5 - xr5*zr5/zl5)^2;
errors(14) = (r21*xl5+r22*yl5+r23*f+r24*f/zl5 - yr5*zr5/zl5)^2;
errors(15) = (r31*xl5+r32*yl5+r33*f+r34*f/zl5 - f*zr5/zl5)^2;

errors(16) =  (dot([r14;r24;r34],[r14;r24;r34])-baseLineLength^2)^2*orthonormalityWeight;

errors(17) =  ((r11^2+r12^2+r13^2 - 1))^2*orthonormalityWeight;
errors(18) =  ((r21^2+r22^2+r23^2 - 1))^2*orthonormalityWeight;
errors(19) =  ((r31^2+r32^2+r33^2 - 1))^2*orthonormalityWeight;

errors(20) =  ((r11*r21+r12*r22+r13*r23)*1)^2*orthonormalityWeight;
errors(21) =  ((r21*r31+r22*r32+r23*r33)*1)^2*orthonormalityWeight;
errors(22) =  ((r11*r31+r12*r32+r13*r33)*1)^2*orthonormalityWeight;

errors'
end

