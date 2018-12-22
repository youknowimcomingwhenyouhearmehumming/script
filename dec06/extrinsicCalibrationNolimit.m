function [R,r0] = extrinsicCalibrationNolimit(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub)

%The guess is perfectly aligned so the search with can be set to the entire
%image
Rguess = eye(3);
r0guess = [-baseLineLength;0;0];
imgH = size(images{1},1);
imgW = size(images{1},2);
searchLineWidtPixels = imgH/2;%passing Phi = 0 and imgW/2 ensures the entire picture is searched by searchEpiLine

N = size(angles,1);
laser_points = zeros(N,2);
camera_points = zeros(N,2);
for i = 1:N %find a single dot, cut out O`ROI and find midpoint. Then convert to image coordinates
[posX1,posY1] = searchEpiLine(images{i}(:,:,1),imgW,imgH,angles(i,1),0,Rguess,r0guess,f,searchLineWidtPixels,pix_W,pix_H);

subMatrixW = 20;
subMatrixH = 20;

[subMatrix1, offsetH1, offsetW1] = subMatrix(images{i}(:,:,1),posX1,posY1,subMatrixW,subMatrixH);

[midOfMass_H1,midOfMass_W1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);

laser_points(i,1) = tan((angles(i,1)-90)*pi/180)*f;
laser_points(i,2) = -tan((angles(i,2))*pi/180)*f;

camera_points(i,1) = -(midOfMass_W1-imgW/2)*pix_W;
camera_points(i,2) = (midOfMass_H1-imgH/2)*pix_H;

end

%copy last constraint so the arrays match the number of images
x0 = [x0 x0(end)*ones(1,(N-5)*2)];
lb = [lb lb(end)*ones(1,(N-5)*2)];
ub = [ub ub(end)*ones(1,(N-5)*2)];

%Set optimizer options and run the minimizer
options = optimoptions(@lsqnonlin,'OptimalityTolerance',10^-10,'StepTolerance',10^-10,'FunctionTolerance',10^-10,'MaxFunctionEvaluations',5000000,'MaxIterations',10000);
x = lsqnonlin(@(x)objectiveNoLimit(x,laser_points,camera_points,f,baseLineLength),x0,lb',ub',options);

x

%Define the Rotation and offset
R = [   x(1) x(2) x(3);
        x(5) x(6) x(7);
        x(9) x(10) x(11)];
    
r0 = [x(4); x(8); x(12)];

%PlotStuff
%% This section only for plotting
%making the plot for the offset:
%R = R*10; %For better plotting
x_axis = R*[100;0;0]+r0;
y_axis = R*[0;100;0]+r0;
z_axis = R*[0;0;100]+r0;


%To test
figure(10);
plot3(0,0,0,'o');

 hold on;
 grid on;
 
 plot3([0 100],[0 0],[0 0],'linewidth',2,'color','b');
 plot3([0 0],[0 100],[0 0],'linewidth',2,'color','b');
 plot3([0 0],[0 0],[0 100],'linewidth',2,'color','b');

% plot3([0 r11]+r14,[0 r21]+r24,[0 r31]+r34)
% plot3([0 r12]+r14,[0 r22]+r24,[0 r32]+r34)
% plot3([0 r13]+r14,[0 r23]+r24,[0 r33]+r34)
plot3(r0(1,1),r0(2,1),r0(3,1),'x');
plot3([r0(1) x_axis(1,1)],[r0(2) x_axis(2,1)],[r0(3) x_axis(3,1)],'linewidth',2,'color','r');
plot3([r0(1) y_axis(1,1)],[r0(2) y_axis(2,1)],[r0(3) y_axis(3,1)],'linewidth',2,'color','r');
plot3([r0(1) z_axis(1,1)],[r0(2) z_axis(2,1)],[r0(3) z_axis(3,1)],'linewidth',2,'color','r');

xlabel('X');
ylabel('Y');
zlabel('Z');
legend('0','X','Y','Z','0','X','Y','Z');
title('Laser(red) in relation to camera(blue)')

% %Plot camera directions
% magnifier = 250;
% camX = -camera_points(:,1)*magnifier
% camY = -camera_points(:,2)*magnifier;
% camZ = -ones(5,1)*f*magnifier;
% 
% plot3([0 camX(1)],[0 camY(1)],[0 camZ(1)],'color','y')
% plot3([0 camX(2)],[0 camY(2)],[0 camZ(2)],'color','m')
% plot3([0 camX(3)],[0 camY(3)],[0 camZ(3)],'color','c')
% plot3([0 camX(4)],[0 camY(4)],[0 camZ(4)],'color','r')
% plot3([0 camX(5)],[0 camY(5)],[0 camZ(5)],'color','g')
% 
% %plot laser directions with rotation
% lasX = -laser_points(:,1)*magnifier;
% lasY = -laser_points(:,2)*magnifier;
% lasZ = -ones(5,1)*f*magnifier;
% 
% 
% rotLas = R*[lasX';lasY';lasZ']+r0;
% lasX = rotLas(1,:)';
% lasY = rotLas(2,:)';
% lasZ = rotLas(3,:)';
% plot3([r0(1) lasX(1)],[r0(2) lasY(1)],[r0(3) lasZ(1)],'color','y')
% plot3([r0(1) lasX(2)],[r0(2) lasY(2)],[r0(3) lasZ(2)],'color','m')
% plot3([r0(1) lasX(3)],[r0(2) lasY(3)],[r0(3) lasZ(3)],'color','c')
% plot3([r0(1) lasX(4)],[r0(2) lasY(4)],[r0(3) lasZ(4)],'color','r')
% plot3([r0(1) lasX(5)],[r0(2) lasY(5)],[r0(3) lasZ(5)],'color','g')

end

