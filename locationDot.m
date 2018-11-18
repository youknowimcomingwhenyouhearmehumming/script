function [location_of_dot_x, location_of_dot_y] = locationDot(image)
%SUBMATRIX Summary of this function goes here. Author=Thor. The meaning of
%this function is that is finds the laser dot and estimate an x,y
%coordinate from one the pixels that belongs to the laser dot. 

%   Detailed explanation goes here
% In order to find the laser dot  the picture is converted into the hsv
% format instead of the RGB format. After this the "mask" is created which
% find all the pixel that should belong to the laser dot. This is done by
% tweeking the parameters of hue and saturation. "mask" ending up been a
% logica matrix with 1 or 0 deping if the statement was satisfied or not. 
% The next step is to find the first element in "mask" that is 1 and the
% take the x and y coordinate of this element. 

hsv = rgb2hsv(image);
figure()
imshow(hsv);

hsv_hue=hsv(:,:,1);


mask=[(hsv(:,:,1)>=0.88)& (hsv(:,:,1)<=0.94) & (hsv(:,:,3)>=0.9)] ;

[location_of_dot_x,location_of_dot_y] = find(mask == 1,1,'first') %finding the first element that is equal to 
% "1" in the first 

%These lines is the manual version of "[location_of_dot_x,location_of_dot_y] = find(mask == 1,1,'first')"
% i=1;
% while(true);
%     if mask(i)==1;
%         location_of_dot=i;
%         break
%     end
% i=i+1;
% end 
% location_of_dot_x=mod(location_of_dot,1080) %taking the modolus
% location_of_dot_y=ceil(location_of_dot/1080) %rounding up to next integer


dot=mask.*hsv;
figure()
imshow(dot);
end

