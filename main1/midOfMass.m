function [midOfMass_H,midOfMass_W] = midOfMass_weighted_sum(submatrix,Wsub,Hsub,offsetW,offsetH)
%SUBsubmatrix Author=Rasmus. The meaning of the function is to determinate the
%middel of the mass of the laser dot based on the subsubmatrix that is
%loaded into the funktion. NOTE!!! that it  calculated the middel of all
%the pixel in the submatrix, so unless that some threshold is added then
%this calculation will be slightly wrong. 
%The outout of the funtion is the mddel of the mass in the height and in
%the width direction
%   Detailed explanation goes here

xsums = sum(submatrix,2);
ysums = sum(submatrix,1);
% figure()
% subplot(2,1,1)
% bar(1:Wsub+1,ysums)
% subplot(2,1,2)
% bar(1:Hsub+1,xsums)
SUM = sum(xsums);
midOfMass_H = (sum(([1:Hsub+1]'.*xsums)')/SUM) + offsetH
midOfMass_W = (sum(([1:Wsub+1].*ysums))/SUM) + offsetW









end

