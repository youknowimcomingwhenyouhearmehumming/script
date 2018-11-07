#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
#include <math.h>

#define areaSize 10

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

	int startPoint = imgW * 50 + 105;
	unsigned char area[areaSize*areaSize];
	int i = 0;
	int j = 0;
	int o = 0;
	int pos = 0;
	int nPointToFind = 6;
	unsigned char** areas = new unsigned char*[nPointToFind];

	///////////////////////
	for (o = 0; o < nPointToFind; o++) {
		for (i = 0; i < areaSize; i++) {
			for (j = 0; j < areaSize; j++) {
				pos = startPoint + j + i*imgW;
				area[i*areaSize + j] = img1->imageData[pos];

				if (i == 0 || i == 9 || j == 0 || j == 9) {//Draw
					img1->imageData[pos] = 0;
				}
			}
		}
		areas[o] = area;
	}
	//////////////////////////////////////
	//Find the spot on pic 2
	
	int* points = new int[nPointToFind];
	int* pointsMatch = new int[nPointToFind];
	for (int g = 0; g < nPointToFind; g++) pointsMatch[g] = 10000;
	int k = 0, l = 0;
	int bestSumPos = 0;
	int pixVal = 0;
	int sumErr = 0;
	int diff = 0;
	for (k = 0; k < imgW*imgH; k++) {
		if (k%imgW < (imgW-10) || k/imgW < (imgH-10)) {
			sumErr = 0;
			///////////////////////
			for (i = 0; i < areaSize; i++) {
				for (j = 0; j < areaSize; j++) {
					pos = k + j + i*imgW;
					pixVal = (unsigned char)img2->imageData[pos];
					diff = abs(pixVal - area[i*areaSize + j]);
					sumErr += diff;
				}
			}
			//////////////////////////
			for (l = 0; l < nPointToFind; l++) {
				if (sumErr < pointsMatch[l]) {
					pointsMatch[l] = sumErr;
					points[l] = k;
					break;
				}
			}
		}
	}
	
	///////////////////////Draw
	for (l = 0; l < nPointToFind; l++)
	{
		for (i = 0; i < areaSize; i++) {
			for (j = 0; j < areaSize; j++) {
				if (i == 0 || i == 9 || j == 0 || j == 9) {
					pos = points[l] + j + i*imgW;
					img2->imageData[pos] = 0;
				}
			}
		}
		printf("%d point x=%d y=%d diff=%d\n", l+1, points[l]%imgW, points[l]/imgW, pointsMatch[l]);
	}
	/////////////////////end draw

	while (1) {
		cvShowImage("Image 1", img1);
		cvShowImage("Image 2", img2);
		if (cvWaitKey(5) > 0)
			break;
	};
	return 0;
}
