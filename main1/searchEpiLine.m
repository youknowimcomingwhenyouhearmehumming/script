function [posX,posY] = searchEpiLine(imageData,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H)
%SEARCHEPILINE Summary of this function goes here
%   Detailed explanation goes here
%searchLineWidhtPixels are applied over and under the line
Theta=-(Theta)*pi/180;
Phi=(Phi+90)*pi/180;

x_lm = f/tan(Theta);
y_lm = f/tan(Phi);

a1 = R(1,1)*x_lm + R(1,2)*y_lm+R(1,3)*f;
a2 = R(2,1)*x_lm + R(2,2)*y_lm+R(2,3)*f;
a3 = R(3,1)*x_lm + R(3,2)*y_lm+R(3,3)*f;

%Define which pixels to look at

z_l = zeros(imgW,1);%we use imgW since all the variation is in this direction unless laser position is completely fucked up
for i = 1:imgW
    z_l(i) = -f*(f*r0(1)-r0(3)*(pix_W*(i-imgW/2)))/(a1*f-a3*(pix_W*(i-imgW/2)));
end

x_cm = f*(a1*z_l+f*r0(1))./(a3*z_l+f*r0(3));
y_cm = f*(a2*z_l+f*r0(2))./(a3*z_l+f*r0(3));

x_cm = round(x_cm./pix_W);
y_cm = round(y_cm./pix_H);

%Find max
maxVal = 0;
for i = 1:imgW*searchLineWidtPixels
    for j = -searchLineWidtPixels:searchLineWidtPixels
        x = mod(i,imgW);
        if imageData(y_cm(x)+j,x_cm(x)) > maxVal
            maxVal = imageData(y_cm(x)+j,x_cm(x));
            posX = x_cm(x);
            posY = y_cm(x)+j;
        end
    end
end

end

