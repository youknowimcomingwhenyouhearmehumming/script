
%       b1    b2    b3    b4    b5    b6    b7    b8    b9
X_measured = [   0;  -190; 0; 250; 0;  0;  -100;   -200;   -300];
Y_measured = [   0;  0;  0;  0;  -21;    0;  0;  0;  0];
Z_measured = [   -1000;  -1000;  -500;   -1000;  -1000;  -1250;  -1250;  -1250; -1250];

Phi = atan(18./sqrt(Z_measured.^2+X_measured.^2))*180/pi;
Phi(5) = atan(-3/sqrt(Z_measured(5)^2+X_measured(5)^2))*180/pi;
Theta = [178;   190;    168;    165;    178;    180;    185;    190;    194]-100;

r0_measured = [-190; -18; 0];
R_measured = eye(3);%We just assume its perf
baseline_measured = 190;
