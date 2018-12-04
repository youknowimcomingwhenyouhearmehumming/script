function [R,r0] = extrinsicCalibration(images,angles,x0,f,baseLineLength,pix_W,pix_H)
%EXTRINSICCALIBRATION Summary of this function goes here
%   Detailed explanation goes here
%baseline length is positive.
Rguess = eye(3);
r0guess = [-baseLineLength;0;0];
imgH = size(images{1},1);
imgW = size(images{1},2);
searchLineWidtPixels = imgH/2;%passing Phi = 0 and imgW/2 ensures the entire picture is searched by searchEpiLine

[posX1,posY1] = searchEpiLine(images{1}(:,:,1),imgW,imgH,angles(1,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);
[posX2,posY2] = searchEpiLine(images{2}(:,:,1),imgW,imgH,angles(1,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);
[posX3,posY3] = searchEpiLine(images{3}(:,:,1),imgW,imgH,angles(1,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);
[posX4,posY4] = searchEpiLine(images{4}(:,:,1),imgW,imgH,angles(1,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);
[posX5,posY5] = searchEpiLine(images{5}(:,:,1),imgW,imgH,angles(1,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);

subMatrixW = 10;
subMatrixH = 10;

[subMatrix1, offsetH1, offsetW1] = subMatrix(images{1}(:,:,1),posX1,posY1,subMatrixW,subMatrixH);
[subMatrix2, offsetH2, offsetW2] = subMatrix(images{2}(:,:,1),posX2,posY2,subMatrixW,subMatrixH);
[subMatrix3, offsetH3, offsetW3] = subMatrix(images{3}(:,:,1),posX3,posY3,subMatrixW,subMatrixH);
[subMatrix4, offsetH4, offsetW4] = subMatrix(images{4}(:,:,1),posX4,posY4,subMatrixW,subMatrixH);
[subMatrix5, offsetH5, offsetW5] = subMatrix(images{5}(:,:,1),posX5,posY5,subMatrixW,subMatrixH);

[midOfMass_H1,midOfMass_W1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
[midOfMass_H2,midOfMass_W2] = midOfMass_gauss(subMatrix2,offsetW2,offsetH2);
[midOfMass_H3,midOfMass_W3] = midOfMass_gauss(subMatrix3,offsetW3,offsetH3);
[midOfMass_H4,midOfMass_W4] = midOfMass_gauss(subMatrix4,offsetW4,offsetH4);
[midOfMass_H5,midOfMass_W5] = midOfMass_gauss(subMatrix5,offsetW5,offsetH5);

laser_points(:,1) = -tan((90-angles(:,1))*pi/180)*f;
laser_points(:,2) = -tan((angles(:,2))*pi/180)*f;

camera_points = [   midOfMass_W1 midOfMass_H1;
                    midOfMass_W2 midOfMass_H2;
                    midOfMass_W3 midOfMass_H3;
                    midOfMass_W4 midOfMass_H4;
                    midOfMass_W5 midOfMass_H5];

camera_points(:,1) = -(camera_points(:,1)-imgW/2)*pix_W;
camera_points(:,2) = (camera_points(:,2)-imgH/2)*pix_H;

%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
lb = [1-0.1   -0.1     -0.1     -260    -0.1     1-0.1     -0.1     -50    -0.1     -0.1     1-0.1     -100    -1400  -1400   -1400   -1000   -1400   -1400   -1400   -1400   -1000   -1400];
ub = [1+0.1   0.1      0.1      -240    0.1      1+0.1     0.1      50     0.1      0.1      1+0.1     100     -1300    -1300    -1300    -800    -1300   -1300    -1300    -1300    -800    -1300];

options = optimoptions(@lsqnonlin,'OptimalityTolerance',10^-10,'StepTolerance',10^-14,'FunctionTolerance',10^-10,'MaxFunctionEvaluations',500000,'MaxIterations',20000);
x = lsqnonlin(@(x)objective(x,laser_points,camera_points,f,baseLineLength),x0',lb',ub',options);
x
R = [   x(1) x(2) x(3);
        x(5) x(6) x(7);
        x(9) x(10) x(11)];
    
r0 = [x(4); x(8); x(12)];

%PlotStuff
%%
%making the plot for the offset:
%R = R*10; %For better plotting
x_axis = R*[10;0;0]+r0;
y_axis = R*[0;10;0]+r0;
z_axis = R*[0;0;10]+r0;


%To test
figure(10);
plot3(0,0,0,'o');

 hold on;
 grid on;
 
 plot3([0 10],[0 0],[0 0],'linewidth',2);
 plot3([0 0],[0 10],[0 0],'linewidth',2);
 plot3([0 0],[0 0],[0 10],'linewidth',2);

% plot3([0 r11]+r14,[0 r21]+r24,[0 r31]+r34)
% plot3([0 r12]+r14,[0 r22]+r24,[0 r32]+r34)
% plot3([0 r13]+r14,[0 r23]+r24,[0 r33]+r34)
plot3(r0(1,1),r0(2,1),r0(3,1),'x');
plot3([r0(1) x_axis(1,1)],[r0(2) x_axis(2,1)],[r0(3) x_axis(3,1)],'linewidth',2);
plot3([r0(1) y_axis(1,1)],[r0(2) y_axis(2,1)],[r0(3) y_axis(3,1)],'linewidth',2);
plot3([r0(1) z_axis(1,1)],[r0(2) z_axis(2,1)],[r0(3) z_axis(3,1)],'linewidth',2);
%plot3(pointsx,pointsy,pointsz,'x')
%axis([-12 2 -12 2 -12 2])
xlabel('X');
ylabel('Y');
zlabel('Z');
legend('0','X','Y','Z','0','X','Y','Z');

end

