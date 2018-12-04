function [subMatrix, offsetH, offsetW] = subMatrix(matrix,pointX,pointY,subMatrixW,subMatrixH)
%SUBMATRIX Summary of this function goes here. Author=Rasmus. Prime goal is
%to cut out a submatrix of the image that is inserted in the function. THis
%cut out will be centered around the x,y coordinated that ´is put into the
%function. 
%   Detailed explanation goes here

subMatrix = zeros(subMatrixH,subMatrixW);
yfrom = (pointY-floor(subMatrixH/2));
yto = (pointY+ceil(subMatrixH/2));
xfrom = (pointX-floor(subMatrixW/2));
xto = (pointX+ceil(subMatrixW/2));

subMatrix = matrix(yfrom+1:yto,xfrom+1:xto);

offsetH = yfrom;
offsetW = xfrom;
end

