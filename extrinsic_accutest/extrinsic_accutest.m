clear;

X = [0;-250;0;250;0];
Y = [0;0;0;0;250];
Z = [-1000;-1000;-500;-1000;-1000];

f = 5;

%
%R = eye(3)
%r0 = [-200;0;0]
%

laser_points = zeros(5,2);
camera_points = zeros(5,2);

laser_points(:,1) = (X+200)./Z*f;
laser_points(:,2) = (Y)./Z*f;

camera_points(:,1) = (X)./Z*f;
camera_points(:,2) = (Y)./Z*f;
baseLineLength = 200;
rad = pi/180;
x00 = [1     0       0       -200    0       1       0       0       0       0       1       0       -1000    -1000    -500    -1000    -1000    -1000    -1000    -500    -1000    -1000];

x0 = [1+cos(5*rad)*2     sin(5*rad)       sin(5*rad)       -210    sin(5*rad)       1+cos(5*rad)*2       -sin(5*rad)       10       -sin(5*rad)       sin(5*rad)       1+cos(5*rad)*2       10       -1010    -1010    -505    -1010    -1010    -1010    -1010    -505    -1010    -1010];

%x = [r11,  r12,    r13,    r14,    r21,    r22,    r23,    r24,    r31,    r32,    r33,    r34,    zl1,    zl2,    zl3,    zl4,    zl5,    zr1,    zr2,    zr3,    zr4,    zr5]
lb = [1-cos(5*rad)*2   -sin(5*rad)    -sin(5*rad)    -210    -sin(5*rad)    1-cos(5*rad)*2     -sin(5*rad)    -10    -sin(5*rad)    -sin(5*rad)    1-cos(5*rad)*2     -10    -1100  -1100   -600   -1100   -1100   -1100   -1100   -600   -1100   -1100];
ub = [1+cos(5*rad)*2   sin(5*rad)     sin(5*rad)     -190    sin(5*rad)     1+cos(5*rad)*2     sin(5*rad)     10     sin(5*rad)     sin(5*rad)     1+cos(5*rad)*2     10     -900    -900    -400    -900    -900   -900    -900    -400    -900    -900];

options = optimoptions(@lsqnonlin,'OptimalityTolerance',10^-10,'StepTolerance',10^-10,'FunctionTolerance',10^-10,'MaxFunctionEvaluations',500000,'MaxIterations',20000);
x = lsqnonlin(@(x)objective(x,laser_points,camera_points,f,baseLineLength),x0',lb',ub',options);

results = x
results-x00'

R = [   x(1) x(2) x(3);
        x(5) x(6) x(7);
        x(9) x(10) x(11)];
    
r0 = [x(4); x(8); x(12)];


R_x0 = [   x0(1) x0(2) x0(3);
        x0(5) x0(6) x0(7);
        x0(9) x0(10) x0(11)];
    
r0_x0 = [x0(4); x0(8); x0(12)];



%%
x_axis = R*[100;0;0]+r0;
y_axis = R*[0;100;0]+r0;
z_axis = R*[0;0;100]+r0;

x_axis_x0 = R_x0*[30;0;0]+r0_x0;
y_axis_x0 = R_x0*[0;30;0]+r0_x0;
z_axis_x0 = R_x0*[0;0;30]+r0_x0;


figure(1)
plot3(0,0,0,'o','color','b')
hold on
grid on

plot3(r0(1,1),r0(2,1),r0(3,1),'x','linewidth',2,'color','r')

plot3(r0_x0(1,1),r0_x0(2,1),r0_x0(3,1),'x','linewidth',1,'color','g')

% plot3([0 r11]+r14,[0 r21]+r24,[0 r31]+r34)
% plot3([0 r12]+r14,[0 r22]+r24,[0 r32]+r34)
% plot3([0 r13]+r14,[0 r23]+r24,[0 r33]+r34)
%plot3(pointsx,pointsy,pointsz,'x')
%axis([-12 2 -12 2 -12 2])

plotCamera('Location',[0;0;0],'Orientation',[0 1 0;1 0 0;0 0 -1],'Size',20,'color','b');

plot3([r0(1) x_axis(1,1)],[r0(2) x_axis(2,1)],[r0(3) x_axis(3,1)],'linewidth',2,'color','r')
plot3([r0(1) y_axis(1,1)],[r0(2) y_axis(2,1)],[r0(3) y_axis(3,1)],'linewidth',2,'color','r')
plot3([r0(1) z_axis(1,1)],[r0(2) z_axis(2,1)],[r0(3) z_axis(3,1)],'linewidth',2,'color','r')

plot3([r0_x0(1) x_axis_x0(1,1)],[r0_x0(2) x_axis_x0(2,1)],[r0_x0(3) x_axis_x0(3,1)],'linewidth',2,'color','g')
plot3([r0_x0(1) y_axis_x0(1,1)],[r0_x0(2) y_axis_x0(2,1)],[r0_x0(3) y_axis_x0(3,1)],'linewidth',2,'color','g')
plot3([r0_x0(1) z_axis_x0(1,1)],[r0_x0(2) z_axis_x0(2,1)],[r0_x0(3) z_axis_x0(3,1)],'linewidth',2,'color','g')


plot3([0 100],[0 0],[0 0],'linewidth',2,'color','b')
plot3([0 0],[0 100],[0 0],'linewidth',2,'color','b')
plot3([0 0],[0 0],[0 100],'linewidth',2,'color','b')
%plot3(X,Y,Z,'r*','linewidth',2,'color','b')

xlabel('X')
ylabel('Y')
zlabel('Z')
legend('Camera','Laser','Minimizer start point')


ptest = [-500;0;-500];
x_axis = R*ptest+r0;
x_axis(1) = x_axis(1) +200;

(ptest-x_axis)./ptest*100




