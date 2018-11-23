#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
#include <math.h>

#define areaSize 10 //dont change
#define nDataPoints 3

void drawTenTen(IplImage* img, int midPoint, int width);

int main(void)
{
	char * fileName;
	int imgH;
	int imgW;
	int imgSize;
	char *  colorFormat = "";

	char* filePath1 = "PIC1_L.png";
	char* filePath2 = "PIC1_R.png";

	IplImage* img1 = cvLoadImage(filePath1, CV_LOAD_IMAGE_GRAYSCALE);
	IplImage* img2 = cvLoadImage(filePath2, CV_LOAD_IMAGE_GRAYSCALE);

	cvNamedWindow("Image 1", CV_WINDOW_AUTOSIZE); // create simple window
	cvNamedWindow("Image 2", CV_WINDOW_AUTOSIZE); // create simple window

	fileName = filePath1;
	imgH = img1->height;
	imgW = img1->width;
	imgSize = img1->imageSize;
	colorFormat = img1->colorModel;

	printf("File Name: %s\nFormat HxW: %d x %d\nImage Size: %d\nColor Format: %s\n\n", fileName, imgH, imgW, imgSize, colorFormat);

	///////////////////////Mark 6 points that are midpoints of a 10*10 patch from pic one
	int p1 = imgW * 50 + 105;
	int p2 = imgW * 150 + 105;
	int p3 = imgW * 50 + 300;
	//int p4 = imgW * 50 + 200;
	//int p5 = imgW * 135 + 467;
	//int p6 = imgW * 120 + 310;

	int pointsToFind[nDataPoints] = { p1, p2, p3};

	////////////////////////Find the spots on pic 2
	int pos1 = 0, pos2 = 0, pix1 = 0, pix2 = 0, pointErr = 0;
	int minErrPoint[nDataPoints] = {10000,10000,10000};
	int minErrPointPos[nDataPoints];
	for (int j = 0; j < nDataPoints; j++) {//for every point to be found
		for (int i = 0; i < imgSize; i++) {//for every pixel
			if(5 <= i%imgW <= (imgW-5) && 5 <= i/imgW <= (imgH - 5)){
			pointErr = 0;
			for (int k = 0; k < areaSize*areaSize; k++) {//for every pixel around the point in a 10*10 square
				//Find the pixel in img 1.
				pos1 = pointsToFind[j] - 4 * imgW + k / 10 * imgW + k % 10;
				pos2 = i - 4 * imgW + k / 10 * imgW + k % 10;
				pix1 = (unsigned char)img1->imageData[pos1];
				pix2 = (unsigned char)img2->imageData[pos2];
				pointErr += abs(pix1 - pix2);
			}

			if (pointErr < minErrPoint[j]) {
				minErrPoint[j] = pointErr;
				minErrPointPos[j] = i;
			}
			}
		}
	}


	for (int i = 0; i<nDataPoints; i++)
		printf("point %d err: %d\n",i,minErrPoint[i]);

	////////////////
	int x1, x2, x3, xm1, xm2, xm3, y1, y2, y3,ym1,ym2,ym3;

		x1 = p1%imgW;
		x2 = p2%imgW;
		x3 = p3%imgW;
		xm1 = minErrPointPos[0] % imgW;
		xm2 = minErrPointPos[1] % imgW;
		xm3 = minErrPointPos[2] % imgW;
		y1 = p1 / imgW;
		y2 = p2 / imgW;
		y3 = p3 / imgW;
		ym1 = minErrPointPos[0] / imgW;
		ym2 = minErrPointPos[1] / imgW;
		ym3 = minErrPointPos[2] / imgW;

		double P0 = (double)-(x1* xm2* y3 - x1* xm3* y2 - x2* xm1* y3 + x2* xm3* y1 + x3* xm1* y2 - x3* xm2* y1) / (x1* y2 - x1* y3 - x2* y1 + x2* y3 + x3* y1 - x3* y2);
		double P1 = (double)(xm1*y2 - xm1*y3 - xm2*y1 + xm2*y3 + xm3*y1 - xm3*y2) / (x1*y2 - x1*y3 - x2*y1 + x2*y3 + x3*y1 - x3*y2);
		double P2 = (double)(x1*xm2 - x1*xm3 - x2*xm1 + x2*xm3 + x3*xm1 - x3*xm2) / (x1*y2 - x1*y3 - x2*y1 + x2*y3 + x3*y1 - x3*y2);
		
		double Q0 = (x1*y2*ym3 - x1*y3*ym2 - x2*y1*ym3 + x2*y3*ym1 + x3*y1*ym2 - x3*y2*ym1) / (x1*y2 - x1*y3 - x2*y1 + x2*y3 + x3*y1 - x3*y2);
		double Q1 = -(y1*ym2 - y1*ym3 - y2*ym1 + y2*ym3 + y3*ym1 - y3*ym2) / (x1*y2 - x1*y3 - x2*y1 + x2*y3 + x3*y1 - x3*y2);
		double Q2 = (x1*ym2 - x1*ym3 - x2*ym1 + x2*ym3 + x3*ym1 - x3*ym2) / (x1*y2 - x1*y3 - x2*y1 + x2*y3 + x3*y1 - x3*y2);

		printf("p0 = %f\np1 = %f\np2 = %f\n", P0, P1, P2);
		printf("q0 = %f\nq1 = %f\nq2 = %f\n", Q0, Q1, Q2);


		///////////Try and create an Image from img 1 and the affine transformation
		int newW = 2 * imgW, newH = 2 * imgH;
		IplImage* newImg = cvCreateImage(cvSize(newW,newH), IPL_DEPTH_8U,1);
		cvNamedWindow("new Image", CV_WINDOW_AUTOSIZE); // create simple window

		int xi = 0, yi = 0;
		int xnew = 0, ynew = 0;
		int offset = newW*0.2*newH+0.1*newW;
		char* data = img1->imageData;
		for (int i = 0; i < imgSize; i++) {
			xi = i%imgW;
			yi = i / imgW;

			xnew = P0 + P1*xi + P2*yi;
			ynew = Q0 + Q1*xi + Q2*yi;

			if (xnew >= 0 && xnew < newW && ynew >= 0 && ynew < newH) {
				newImg->imageData[xnew + ynew*newW + offset] = data[i];
			}
		}



		//////////////////////draw all the squares
	for (int i = 0; i<nDataPoints; i++)
		drawTenTen(img1, pointsToFind[i], imgW);
	for (int i = 0; i<nDataPoints; i++)
		drawTenTen(img2, minErrPointPos[i], imgW);
	/////////////////////////////////////
	while (1) {
		cvShowImage("Image 1", img1);
		cvShowImage("Image 2", img2);
		cvShowImage("new Image", newImg);
		if (cvWaitKey(5) > 0)
			break;
	};
	return 0;
}


void drawTenTen(IplImage* img, int midPoint, int width) {
	for (int i = 0; i < 10; i++) {
		img->imageData[midPoint - 4 - width * 4 + i] = 0;
		img->imageData[midPoint - 4 + width * 5 + i] = 0;
		img->imageData[midPoint - 4 - width * 4 + i*width] = 0;
		img->imageData[midPoint + 5 - width * 4 + i*width] = 0;
	}
}