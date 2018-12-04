function [c,ceq] = UnlConFun(x,baselineLength)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
baselineLength;
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

c = [];
ceq = zeros(7,1);
ceq(1) = abs(dot([r14;r24;r34],[r14;r24;r34])-baselineLength^2);

ceq(2) = abs((r11^2+r12^2+r13^2 - 1));
ceq(3) = abs((r21^2+r22^2+r23^2 - 1));
ceq(4) = abs((r31^2+r32^2+r33^2 - 1));

ceq(5) = abs((r11*r21+r12*r22+r13*r23)*1);
ceq(6) = abs((r21*r31+r22*r32+r23*r33)*1);
ceq(7) = abs((r11*r31+r12*r32+r13*r33)*1);

end

