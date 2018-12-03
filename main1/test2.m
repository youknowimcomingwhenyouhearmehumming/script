clear;


camlist = webcamlist;
cam = webcam('C922');
cam.AvailableResolution;
cam.Resolution = '2304x1536';
% image = preview(cam)
% 
% %%
img = snapshot(cam);
figure()
imshow(img)
imwrite(img, 'intrinsic01.tif');

% i=1;
% while true
%     i
%         if i==i>5
%             break
%         end
%     img = snapshot(cam);
% 
%     sprintf ( 'Testpictures%i.tif', i )=snapshot(cam);;
%     %%%---------------------Take an image%pick a camera----------------------
% %     pic = snapshot(cam);
%     
% end 

    