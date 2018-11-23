clear;
pi = 3.1415;

%%
%Parameters
Theta = 40;%degfrom x axis toward neg z axis(toward world)
Phi = 20;%deg from x axis toward y (up)
Theta=-(Theta)*pi/180;
Phi=(Phi+90)*pi/180;

R = [1 0 0;
     0 1 0;
     0 0 1];
r0 = [-10;0;0];

f = 6;
%%

x_lm = f/tan(Theta);
y_lm = f/tan(Phi);

a1 = R(1,1)*x_lm + R(1,2)*y_lm+R(1,3)*f;
a2 = R(2,1)*x_lm + R(2,2)*y_lm+R(2,3)*f;
a3 = R(3,1)*x_lm + R(3,2)*y_lm+R(3,3)*f;

z_l = [-10 -5 -1 -0.1 0.1 1 5 10]';

x_cm = f*(a1*z_l+f*r0(1))./(a3*z_l+f*r0(3));
y_cm = f*(a2*z_l+f*r0(2))./(a3*z_l+f*r0(3));


%%
%Plotting
x_axis = R*[5;0;0]+r0;
y_axis = R*[0;5;0]+r0;
z_axis = R*[0;0;5]+r0;

ray = -10*[a1;a2;a3]+[r0(1);r0(2);r0(3)];

figure(1)
subplot(1,3,1)
plot([0 5],[0 0],'LineWidth',2,'color','b')
hold on
plot([0 0],[0 5],'LineWidth',2,'color','b')
plot([r0(1) x_axis(1,1)],[r0(3) x_axis(3,1)],'LineWidth',2,'color','r')
plot([r0(1) z_axis(1,1)],[r0(3) z_axis(3,1)],'LineWidth',2,'color','r')
plot([r0(1) ray(1)],[r0(3) ray(3)],'LineWidth',2,'color','g')
title('Bottom view')
xlabel('X')
ylabel('Z')
axis([-10 10 -15 5])


subplot(1,3,2)
plot([0 5],[0 0],'LineWidth',2,'color','b')
hold on
plot([0 0],[0 5],'LineWidth',2,'color','b')
plot([r0(3) z_axis(3,1)],[r0(2) z_axis(2,1)],'LineWidth',2,'color','r')
plot([r0(3) y_axis(3,1)],[r0(2) y_axis(2,1)],'LineWidth',2,'color','r')
plot([r0(3) ray(3)],[r0(2) ray(2)],'LineWidth',2,'color','g')
title('Side view')
xlabel('Z')
ylabel('Y')
axis([-12 8 -2 18])

% plot3([0 5],[0 0],[0 0],'LineWidth',2,'color','b')
% hold on
% grid on
% plot3([0 0],[0 5],[0 0],'LineWidth',2,'color','b')
% plot3([0 0],[0 0],[0 5],'LineWidth',2,'color','b')
% plot3([r0(1) x_axis(1,1)],[r0(2) x_axis(2,1)],[r0(3) x_axis(3,1)],'LineWidth',2,'color','r')
% plot3([r0(1) y_axis(1,1)],[r0(2) y_axis(2,1)],[r0(3) y_axis(3,1)],'LineWidth',2,'color','r')
% plot3([r0(1) z_axis(1,1)],[r0(2) z_axis(2,1)],[r0(3) z_axis(3,1)],'LineWidth',2,'color','r')
% plot3([r0(1) ray(1)],[r0(2) ray(2)],[r0(3) ray(3)],'LineWidth',2,'color','g')
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis([-10 10 0 20 -15 5])
% title('Camera(blue) and Laser(red) positions')

subplot(1,3,3)
plot(x_cm,y_cm,'LineWidth',2,'color','b')
hold on
plot(0,0,'o','LineWidth',2,'color','b')
axis([-50 50 -50 50])
xlabel('x_c [mm]')
ylabel('y_c [mm]')
title('Camera image plane')
plot(x_lm,y_lm,'x')