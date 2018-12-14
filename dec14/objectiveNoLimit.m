function errors = objectiveNoLimit(x,laser_points,camera_points,f,baseLineLength)
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
orthonormalityWeight = 100;

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

%%
N = size(laser_points,1);
zl = zeros(N,1);
zr = zeros(N,1);
xl = zeros(N,1);
yl = zeros(N,1);
xr = zeros(N,1);
yr = zeros(N,1);

for i = 1:N
    zl(i) = x(1,13+(2*i)-2);
    zr(i) = x(1,14+(2*i)-2);
    xl(i) = laser_points(i,1);
    yl(i) = laser_points(i,2);
    xr(i) = camera_points(i,1);
    yr(i) = camera_points(i,2);
end

%%
errors = zeros(N*3+7,1);


for i = 1:N
    errors((i-1)*3+1) = (r11*xl(i)+r12*yl(i)+r13*f+r14*f/zl(i) - (xr(i)*zr(i)/zl(i)))^2;
    errors((i-1)*3+2) = (r21*xl(i)+r22*yl(i)+r23*f+r24*f/zl(i) - (yr(i)*zr(i)/zl(i)))^2;
    errors((i-1)*3+3) = (r31*xl(i)+r32*yl(i)+r33*f+r34*f/zl(i) - (f*zr(i)/zl(i)))^2;
end


errors(N*3+1) =  (dot([r14;r24;r34],[r14;r24;r34])-baseLineLength^2)^2*orthonormalityWeight;

errors(N*3+2) =  ((r11^2+r12^2+r13^2 - 1))^2*orthonormalityWeight;
errors(N*3+3) =  ((r21^2+r22^2+r23^2 - 1))^2*orthonormalityWeight;
errors(N*3+4) =  ((r31^2+r32^2+r33^2 - 1))^2*orthonormalityWeight;

errors(N*3+5) =  ((r11*r21+r12*r22+r13*r23)*1)^2*orthonormalityWeight;
errors(N*3+6) =  ((r21*r31+r22*r32+r23*r33)*1)^2*orthonormalityWeight;
errors(N*3+7) =  ((r11*r31+r12*r32+r13*r33)*1)^2*orthonormalityWeight;


errors'
end

