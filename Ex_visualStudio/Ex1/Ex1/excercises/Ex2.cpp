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
	int nChannels;
	char *  colorFormat = "";
	char * imgData;

	char* filePath = "pen.pgm";

	IplImage* img = cvLoadImage(filePath, CV_LOAD_IMAGE_GRAYSCALE);
	IplImage* copy = cvCloneImage(img);

	cvNamedWindow("My image", CV_WINDOW_AUTOSIZE); // create simple window
	cvNamedWindow("My Clone", CV_WINDOW_AUTOSIZE); // create simple window

	fileName = filePath;
	imgH = img->height;
	imgW = img->width;
	imgSize = img->imageSize;
	colorFormat = img->colorModel;
	imgData = img->imageData;
	nChannels = img->nChannels;

	printf("File Name: %s\nFormat HxW: %d x %d\nImage Size: %d\nColor Format: %s\nNumber of Cannels: %d\n", fileName, imgH, imgW, imgSize, colorFormat, nChannels);

	int thresh = 100;

	/////////Histogram//////////////////////////////////
	unsigned int histogram[256];
	char *channel = imgData;
	int width = imgW;
	int height = imgH;
	unsigned char value = 0; // index value for the histogram (not really needed)
	int k = 256;
	while (k-- > 0)
		histogram[k] = 0; // reset histogram entry
	for (int i = 0; i < width*height; i++)
	{
		value = channel[i];
		histogram[value] += 1;

		//CHANGE copy with thresh hold//////
		if (value >= thresh)
			copy->imageData[i] = 255;
		else
			copy->imageData[i] = 0;
		//////////////////////////////////
	}

	//Draw Histogram
	IplImage* imgHistogram = cvCreateImage(cvSize(256,700), 8, 1);
	cvNamedWindow("My histogram", CV_WINDOW_AUTOSIZE);
	int i = 0;
	for (i = 0; i < 256; i++)
	{
		cvLine(imgHistogram, cvPoint(i, 700), cvPoint(i, 700-histogram[i]/10), CV_RGB(255, 100, 100), 2, 8);
	}

	//Calc center of mass
	double M10 = 0, M01 = 0, M00 = 0;
	int bitVal, y=0, x=0;
	double M11 = 0,M20 = 0,M02 = 0;

	for (i = 0; i < imgH*imgW; i++)
	{
		y = i / (width);
		x = i % (width);


		if ((unsigned char)copy->imageData[i] == 255)
			bitVal = 0;
		else
			bitVal = 1;

		M00 = M00 + bitVal;
		M10 = M10 + bitVal*x;
		M01 = M01 + bitVal*y;

		//For use in calculation of moments
		M11 = M11 + bitVal*x*y;
		M20 = M20 + bitVal*x*x;
		M02 = M02 + bitVal*y*y;

	}
	int centerX = M10 / M00; //
	int centerY = M01 / M00; //

	cvSaveImage("binary_pen.pgm", copy, 0);

	//x = 0;
	//y = 0;
	//long int mu20=0, mu11=0, mu02=0;
	//for (i = 0; i < imgH*imgW; i++)
	//{
	//	y = i / (width);
	//	x = i % (width);


	//	if ((unsigned char)copy->imageData[i] == 255)
	//		bitVal = 0;
	//	else
	//		bitVal = 1;
	//	
	//	//For use in calculation of moments
	//	mu11 = mu11 + (long int)bitVal*(x*-centerX)*(y*-centerY);
	//	mu20 = mu20 + (long int)bitVal*(x*-centerX)^2;
	//	mu02 = mu02 + (long int)bitVal*(y*-centerY)^2;
	//}

	double mu11 = M11 - (double)centerY*centerX*M00;
	double mu11_m = mu11 / M00;
	double mu20 = M20 - (double)centerX*M10;
	double mu20_m = mu20 / M00;
	double mu02 = M02 - (double)centerY*M01;
	double mu02_m = mu02 / M00;
	double tan2phi = 2 * (double)mu11_m / ((double)(mu20_m - mu02_m));
	//double tan2phi = 2 * ((double)b/M00) / ((double)(a - c)/M00);
	double phi_rad =atan2(tan2phi,tan2phi) / 2;  //////////////////////////////////////////////////FIX TAN" PHI HER!
	double phi = phi_rad*180/ (3.1415);

	printf("center x: %d\ncenter y: %d\n", centerX, centerY);
	printf("M10: %f\n", M10);
	printf("M01: %f\n", M01);
	printf("M11: %f  mu11: %f  mu11_m: %f\n", M11,mu11,mu11_m);
	printf("M20: %f  mu20: %f  mu20_m: %f\n", M20, mu20, mu20_m);
	printf("M02: %f  mu02: %f  mu02_m: %f\n", M02, mu02, mu02_m);
	printf("tan(2*phi): %f  phi rad: %f  phi: %f\n", tan2phi, phi_rad, phi);
	//Draw x
	cvLine(copy, cvPoint(centerX + 5, centerY + 5), cvPoint(centerX - 5, centerY - 5), CV_RGB(100, 100, 100), 2, 8);
	cvLine(copy, cvPoint(centerX - 5, centerY + 5), cvPoint(centerX + 5, centerY - 5), CV_RGB(100, 100, 100), 2, 8);

	//EX2_3
	int x1 = (float)centerX + cos(phi_rad) * (float)50;
	int y1 = (float)centerY + sin(phi_rad) * (float)50;
	int x2 = (float)centerX - cos(phi_rad) * (float)50;
	int y2 = (float)centerY - sin(phi_rad) * (float)50;
	cvLine(copy, cvPoint(centerX, centerY), cvPoint(x1, y1), CV_RGB(100, 100, 100), 2, 8);
	cvLine(copy, cvPoint(centerX, centerY), cvPoint(x2, y2), CV_RGB(100, 100, 100), 2, 8);

	 
	//Show windows
	while (1) {
		cvShowImage("My Image", img);
		cvShowImage("My Clone", copy);
		cvShowImage("My histogram", imgHistogram);
		if (cvWaitKey(5) > 0)
			break;
	};
}
