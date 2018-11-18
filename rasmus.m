clear;
original = imread('b1.jpg');
figure(2)
imshow(original);
original1 = original(:,:,1);

% [maxX,maxY,maxVal] = matrixMax(original1);

maxX=590;
maxY=988;

Wsub = 150;
Hsub = 150;
[submatrix,offsetH,offsetW] = subMatrix(original1,maxX,maxY,Wsub,Hsub)
figure(1)
imshow(submatrix);


xsums = sum(submatrix,2);
ysums = sum(submatrix,1);

figure(3)
subplot(2,1,1)
bar(1:Wsub+1,ysums)
subplot(2,1,2)
bar(1:Hsub+1,xsums)

SUM = sum(xsums);
masssMid_H = (sum(([1:Hsub+1]'.*xsums)')/SUM) + offsetH;
masssMid_W = (sum(([1:Wsub+1].*ysums))/SUM) + offsetW;

