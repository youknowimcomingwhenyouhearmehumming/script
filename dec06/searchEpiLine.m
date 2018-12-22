function [posX,posY] = searchEpiLine(imageData,imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H)

%searchLineWidhtPixels are applied over and under the line

x_lm = tan((Theta-90)*pi/180)*f; 
y_lm = -tan(Phi*pi/180)*f;

a1 = R(1,1)*x_lm + R(1,2)*y_lm+R(1,3)*f;
a2 = R(2,1)*x_lm + R(2,2)*y_lm+R(2,3)*f;
a3 = R(3,1)*x_lm + R(3,2)*y_lm+R(3,3)*f;

%Define which pixels to look at
z_l = zeros(imgW,1);%we use imgW since all the variation is in this direction unless laser position is completely off
for i = 1:imgW
    z_l(i) = -f*(f*r0(1)-r0(3)*(pix_W*(i-imgW/2)))/(a1*f-a3*(pix_W*(i-imgW/2)));
end

x_cm = f*(a1*z_l+f*r0(1))./(a3*z_l+f*r0(3));
y_cm = f*(a2*z_l+f*r0(2))./(a3*z_l+f*r0(3));

%round the values if they are not intergers
x_cm = round(x_cm./pix_W)+0.5*imgW;
y_cm = round(y_cm./pix_H)+0.5*imgH;

%Find max
maxVal = 0;
for i = 1:imgW
    for jj = 1:searchLineWidtPixels*2
        if imageData(y_cm(i)+jj-searchLineWidtPixels,x_cm(i)) > maxVal
            maxVal = imageData(y_cm(i)+jj-searchLineWidtPixels,x_cm(i));
            posX = x_cm(i);
            posY = y_cm(i)+jj-searchLineWidtPixels;
        end
    end
end

if maxVal<10%if intensity is too low it can be disregarded. to avoid program out of bounds
            posX = 0;
            posY = 0;
end

end

