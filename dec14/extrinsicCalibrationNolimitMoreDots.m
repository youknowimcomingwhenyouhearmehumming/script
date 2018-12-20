function [R,r0] = extrinsicCalibrationNolimitMoreDots(images,angles,x0,f,baseLineLength,pix_W,pix_H,lb,ub,imgW,imgH)
%EXTRINSICCALIBRATION Summary of this function goes here
%   Detailed explanation goes here
%baseline length is positive.


Rguess = eye(3);
r0guess = [-baseLineLength;0;0];

Rguess =[0.998428713288284,0.021576452007944,-0.052604641996046;-0.021885882827788,0.999695339332310,-0.005738177525150;0.052236834952218,0.007175535933858,0.998670148774127];
r0guess =[-1.999998081262345e+02;-0.104148592458888;-0.258060086069151];

imgH = size(images{1},1);
imgW = size(images{1},2);

N = 0;
laser_points = [];
camera_points = [];

for i = 1:length(images)
    figure(i)
    imshow(images{i}(:,:,1))
    hold on
    for j = 1:5%15dots per image
        [camera_point_x,camera_point_y,laser_point_x,laser_point_y] = findCameraAndLaserPoint(images{i}(:,:,1),angles(i*5-5+j,1),angles(i*5-5+j,2),Rguess,r0guess,f,pix_W,pix_H,imgW,imgH);
        if isnan(camera_point_x)
            %dont use this point
        else
            N = N+1;
            camera_points = [camera_points; camera_point_x camera_point_y];
            laser_points = [laser_points; laser_point_x laser_point_y];
        end
    end
end

%nonlcon = @UnlConFun;
%options = optimoptions(@fmincon,'OptimalityTolerance',10^-10,'StepTolerance',10^-12,'FunctionTolerance',10^-10,'MaxFunctionEvaluations',50000,'MaxIterations',10000);
%x = fmincon(@(x)objectiveFmincon(x,laser_points,camera_points,f,baseLineLength),x0',[],[],[],[],lb',ub',@(x)nonlcon(x,baseLineLength),options);

x0 = [x0 x0(end)*ones(1,(N-5)*2)];
lb = [lb lb(end)*ones(1,(N-5)*2)];
ub = [ub ub(end)*ones(1,(N-5)*2)];

options = optimoptions(@lsqnonlin,'OptimalityTolerance',10^-6,'StepTolerance',10^-6,'FunctionTolerance',10^-8,'MaxFunctionEvaluations',50000,'MaxIterations',10000);
x = lsqnonlin(@(x)objectiveNoLimit(x,laser_points,camera_points,f,baseLineLength),x0',lb',ub',options);

x
R = [   x(1) x(2) x(3);
        x(5) x(6) x(7);
        x(9) x(10) x(11)];
    
r0 = [x(4); x(8); x(12)];

%PlotStuff
%%
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
 
 plot3([0 100],[0 0],[0 0],'linewidth',2);
 plot3([0 0],[0 100],[0 0],'linewidth',2);
 plot3([0 0],[0 0],[0 100],'linewidth',2);

% plot3([0 r11]+r14,[0 r21]+r24,[0 r31]+r34)
% plot3([0 r12]+r14,[0 r22]+r24,[0 r32]+r34)
% plot3([0 r13]+r14,[0 r23]+r24,[0 r33]+r34)
plot3(r0(1,1),r0(2,1),r0(3,1),'x');
plot3([r0(1) x_axis(1,1)],[r0(2) x_axis(2,1)],[r0(3) x_axis(3,1)],'linewidth',2);
plot3([r0(1) y_axis(1,1)],[r0(2) y_axis(2,1)],[r0(3) y_axis(3,1)],'linewidth',2);
plot3([r0(1) z_axis(1,1)],[r0(2) z_axis(2,1)],[r0(3) z_axis(3,1)],'linewidth',2);

xlabel('X');
ylabel('Y');
zlabel('Z');
legend('0','X','Y','Z','0','X','Y','Z');


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

