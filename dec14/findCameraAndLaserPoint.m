function [camera_point_x,camera_point_y,laser_point_x,laser_point_y] = findCameraAndLaserPoint(image,Theta,Phi,R,r0,f,pix_W,pix_H,imgW,imgH)
%FINDCAMERAPOINT Summary of this function goes here
%   Detailed explanation goes here
try
    searchLineWidtPixels = 10;
    [posX1,posY1] = searchEpiLine(image(:,:,1),imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
    
    subMatrixW = 20;
    subMatrixH = 20;
    
    [subMatrix1, offsetH1, offsetW1] = subMatrix(image(:,:,1),posX1,posY1,subMatrixW,subMatrixH);
    
    [midOfMass_H1,midOfMass_W1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
    
    laser_point_x = tan((Theta-90)*pi/180)*f;
    laser_point_y = -tan((Phi)*pi/180)*f;
    
    camera_point_x = -(midOfMass_W1-imgW/2)*pix_W;
    camera_point_y = (midOfMass_H1-imgH/2)*pix_H;
    
    figure
    imshow(image)
    hold on
    plot(midOfMass_W1,midOfMass_H1,'x')
catch
    laser_point_x=NaN;
    laser_point_y=NaN;
    camera_point_x=NaN;
    camera_point_y=NaN;
end
end

