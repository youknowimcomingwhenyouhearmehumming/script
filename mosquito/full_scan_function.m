

function [X,Y,Z] = full_scan_function(R,r0,rod_name_of_files)


b0_theta = 70.8;
stepsize = 0.5;
number_of_pictures=47; 
phi_0_angel=10; 
Angel_between_phi_dots=5;
number_of_dots_in_fane=5;

i = 0;
X = zeros(number_of_pictures,number_of_dots_in_fane)
Y = zeros(number_of_pictures,number_of_dots_in_fane)
Z = zeros(number_of_pictures,number_of_dots_in_fane)

figure(6)
for i = 0:number_of_pictures
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get angles
for j = 0:number_of_dots_in_fane
Phi = phi_0_angel+j*Angel_between_phi_dots;
Theta = b0_theta+i*stepsize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Get images
try
img_name = [rod_name_of_files num2str(Theta) '.tif'];
img_1 = undistortImage(imread(img_name),cameraParams);
catch
    skip = 1;
end
if skip ~= 1


%%%%%%%%%%%%%%%%%%%%%%%%%%%Find the dot
searchLineWidtPixels = 20;
[posX1,posY1] = searchEpiLine(img_1(:,:,1),imgW,imgH,Theta,Phi,R,r0,f,searchLineWidtPixels,pix_W,pix_H);
if posX1 <= 10 || posY1 <= 10
    break;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%Cut out the dot
Wsub = 40;
Hsub = 40;
[subMatrix1, offsetH1, offsetW1] = subMatrix(img_1(:,:,1),posX1,posY1,Wsub,Hsub);
%%%%%%%%%%%%%%%%%%%%%%%%%%%Find mid of the dot
[ymid_1,xmid_1] = midOfMass_gauss(subMatrix1,offsetW1,offsetH1);
%Convert from pixel value to mm and move origo to middle
xmid1_mm = (xmid_1-imgW/2)*pix_W;
ymid1_mm = (ymid_1-imgH/2)*pix_H;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%Find world coordinate


[x,y,z] = calcWorldPosition(Theta,Phi,xmid1_mm,ymid1_mm,f,R,r0);
X(i+1) = x;
Y(i+1) = y;
Z(i+1) = z;
end
skip = 0;
end

end


end 




