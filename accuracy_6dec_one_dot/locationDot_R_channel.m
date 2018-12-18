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

% The next line is used for HSV
% hsv = rgb2hsv(image);
% figure()
% imshow(hsv);
% 
% mask=[(hsv(:,:,1)>=0.91| hsv(:,:,1)==0)& (hsv(:,:,3)>=0.05) ] ;
% dot=mask.*hsv;
% figure()
% imshow(dot);

% The next line is used for RGB

image_changed=image; %A copy is taken since this every found laser dot will be painted black in order to 
%find  the next laser dot
location_of_dot_x=[]; %This create a list of the coordinates for the laser dots. 
location_of_dot_y=[];
half_size_of_dot=15;

i=1;
while true
    
    [y,x] = find(image_changed == max(image_changed(:)));
%     max(image_changed(:)) %activate this is the max value should be shown
%     x(1)
%     y(1)
%     image_changed(y(1),x(1))
    if image_changed(y(1),x(1))>100 %If the intensity drops below 20 then it's assumed 
%     i
%     [y,x] = find(max(image)) %CHEK AT X OG Y IKKE ER BYTTET OM!!!
    x=x(1); %The reason for this and the next line is that the find() funktion writes several
    %coordinates down is severel elements have the maximum intensity value.
    %E.g. if two elements  both are at 120. With these two lines only of of
    %those elements are feed forward. So even if the treshold is set to 0
    %in intensity you still only get three coordinates out since so many of
    %them have 1,2,3 in intensity (since that is the background. )
    y=y(1);
    location_of_dot_x(i)=x();
    location_of_dot_y(i)=y();
    
    for j=x-half_size_of_dot:x+half_size_of_dot % This loop plaint the found laser dot black
        for k=y-half_size_of_dot:y+half_size_of_dot
            image_changed(k,j)=0;
        end
    end
    

        
    else
        'break'
        break
    end
   
    i=i+1;
    
end 
figure()
imshow(image_changed)
%The next part is only to see the change images
% figure()
% imshow(image_changed);



% The next two lines are the old aproach to find the laser dot 
% mask=[image(:,:,1)>=10]; 
% [location_of_dot_x,location_of_dot_y] = find(mask == 1,1,'first') ;%finding the first element that is equal to 


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



end

