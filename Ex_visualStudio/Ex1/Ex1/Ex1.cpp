#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
int* histogram(unsigned char *channel, int width, int height) {
	unsigned char value = 0; // index value for the histogram (not really needed)
	int histogram[256]; // histogram array - remember to set to zero initially
	int k = 256;
	while (k-- > 0)
		histogram[k] = 0; // reset histogram entry
	for (int i = 0; i < width*height; i++)
	{
		value = channel[i];
		histogram[value] += 1;
	}

	return histogram;
}


int main(int argc, char* argv[])
{
	char * fileName;
	int imgH;
	int imgW;
	int imgSize;
	char *  colorFormat = "";
	char * imgData;

	char* filePath = "ariane5_1b.jpg";

	IplImage* img = cvLoadImage(filePath,CV_LOAD_IMAGE_COLOR);

	fileName = filePath;
	imgH = img->height;
	imgW = img->width;
	imgSize = img->imageSize;
	colorFormat = img->colorModel;
	imgData = img->imageData;

	printf("File Name: %s\nFormat HxW: %d x %d\nImage Size: %d\nColor Format: %s\n\n", fileName, imgH, imgW, imgSize, colorFormat);


	//Define a window
	const char* wName = "My image"; // window name
	cvNamedWindow(wName, CV_WINDOW_AUTOSIZE); // create simple window

	//Define a window
	//const char* w2Name = "My Histogram"; // window name
	//cvNamedWindow(w2Name, CV_WINDOW_AUTOSIZE); // create simple window

	//load image in grayscale
	//IplImage * gray = cvLoadImage(filePath, CV_LOAD_IMAGE_GRAYSCALE);


	
	//cvCvtColor(img, copy, CV_RGB2GRAY);

	//Create histogram of image
	int channelSize = imgSize/3;
	unsigned char* R = new unsigned char[channelSize];
	unsigned char* G = new unsigned char[channelSize];
	unsigned char* B = new unsigned char[channelSize];

	int i = 0;
	int j = 0;
	while ( i < imgSize)
	{
		R[j] = imgData[i];
		G[j] = imgData[i+1];
		B[j] = imgData[i + 2];
		j++;
		i = i + 3;
	}

	int* Rhisto = histogram(R, imgW,imgH);
//	IplImage* Ghisto = histogram(G, imgW, imgH);
//	IplImage* Bhisto = histogram(B, imgW, imgH);


	CvSize histSize;
	histSize.width = 256;
	histSize.height = 100;
	IplImage* histImg = cvCreateImage(histSize, 1, 1);
	CvPoint p1;
	CvPoint p2;
	CvScalar color = cvScalar(200);

	//for (i = 0; i < 256; i++)
	//{

	//	p1.x = i;
	//	p1.y = 0;
	//	p2.x = i;
	//	p2.y = Rhisto[i];

	//	cvLine(histImg, p1, p2, CV_RGB(255,100,100), 2, 8);
	//}

	//for (i = 1; i < 255; i++) {
	//	for (int j = 0; j < (Rhisto[i]);j++)
	//		printf("l");
	//	printf("\n");
	//}

	while (1) {
		cvShowImage("MyHistogram", histImg);
		cvShowImage("MyImage", img);
		if (cvWaitKey(5) > 0)
			break;
	};
	

	return 0;
}


