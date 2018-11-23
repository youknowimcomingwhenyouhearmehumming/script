#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
#include <math.h>


int main(int argc, char* argv[])
{
	char * fileName;
	int imgH;
	int imgW;
	int imgSize;
	char *  colorFormat = "";
	unsigned char * imgData;

	char* filePath = "mountain.jpg";

	IplImage* img = cvLoadImage(filePath, CV_LOAD_IMAGE_GRAYSCALE);
	IplImage* copy = cvCloneImage(img);
	IplImage* copy2 = cvCloneImage(img);

	cvNamedWindow("My image", CV_WINDOW_AUTOSIZE); // create simple window
	cvNamedWindow("Filtered", CV_WINDOW_AUTOSIZE); // create simple window
	cvNamedWindow("2.Filtered", CV_WINDOW_AUTOSIZE); // create simple window

	fileName = filePath;
	imgH = img->height;
	imgW = img->width;
	imgSize = img->imageSize;
	colorFormat = img->colorModel;
	imgData = (unsigned char *)img->imageData;

	printf("File Name: %s\nFormat HxW: %d x %d\nImage Size: %d\nColor Format: %s\n\n", fileName, imgH, imgW, imgSize, colorFormat);
	/////////////////////////////////////////////////
	int64 cvFilterCountStart = cvGetTickCount();
	float kdata[] = {1,1,1,1,1,1,1,1,1};

	for (int i = 0; i < 9; i++)
		kdata[i] = kdata[i] / 9;

	CvMat kernel = cvMat(3, 3, CV_32F, kdata);

	cvFilter2D(img, copy2, &kernel);
	int64 cvFilterCountStop = cvGetTickCount();
	//////////////////////////////////////////////////
	int64 myFiltCountStart = cvGetTickCount();
	int x = 0, y = 0;
	int i = 0;

	unsigned char *cpyData =(unsigned char*) copy->imageData;

	int filterSum = 0;
	for (i = 0; i < imgH*imgW; i++)
	{
		y = i / (imgW);
		x = i % (imgW);

		filterSum = 0;

			if (y == 0 || y == (imgH-1) || x == (imgW - 1) || x == 0)
			{
				//copy->imageData[i] = imgData[i];
			}else{

			filterSum = filterSum - imgData[i-1-imgW]	;
			filterSum = filterSum - imgData[i-imgW]		;
			filterSum = filterSum - imgData[i+1-imgW]	;
			filterSum = filterSum - imgData[i-1]		;
			filterSum = filterSum + 8*imgData[i]		;
			filterSum = filterSum - imgData[i+1]		;
			filterSum = filterSum - imgData[i-1+imgW]	;
			filterSum = filterSum - imgData[i+imgW]		;
			filterSum = filterSum - imgData[i+1+imgW]	;

			filterSum += 127;//lift so we can see both neg and pos effects
			if (filterSum > 255)
				filterSum = 255;
			if (filterSum < 0)
				filterSum = 0;
			cpyData[i] = filterSum;
		}
	}
	int64 myFiltCountStop = cvGetTickCount();
	//////////////////////////////////////////////////


	printf("Elapsed time of Cv Filter: %f\n",(double) cvFilterCountStop - cvFilterCountStart);
	printf("Elapsed time of my Filter: %f\n",(double) myFiltCountStop - myFiltCountStart);


	while (1) {
		cvShowImage("2.Filtered", copy2);
		cvShowImage("My image", img);
		cvShowImage("Filtered", copy);
		if (cvWaitKey(5) > 0)
			break;
	};

	return 0;
}