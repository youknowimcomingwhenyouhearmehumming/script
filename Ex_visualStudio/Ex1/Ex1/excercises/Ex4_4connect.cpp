#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
#include <math.h>

#define MAX_RAND 10000

int main(void)
{
	char * fileName;
	int imgH;
	int imgW;
	int imgSize;
	char *  colorFormat = "";
	unsigned char * imgData;

	char* filePath = "pen snip.jpg";

	IplImage* img = cvLoadImage(filePath, CV_LOAD_IMAGE_GRAYSCALE);
	IplImage* copy = cvCloneImage(img);
	cvNamedWindow("My image", CV_WINDOW_AUTOSIZE); // create simple window
	cvNamedWindow("Rim", CV_WINDOW_AUTOSIZE); // create simple window

	fileName = filePath;
	imgH = img->height;
	imgW = img->width;
	imgSize = img->imageSize;
	colorFormat = img->colorModel;
	imgData = (unsigned char *)img->imageData;

	printf("File Name: %s\nFormat HxW: %d x %d\nImage Size: %d\nColor Format: %s\n\n", fileName, imgH, imgW, imgSize, colorFormat);

	int thresh = 100;
	for (int i = 0; i < imgW*imgH; i++)
	{
		//CHANGE copy with thresh hold//////
		if ((unsigned char)img->imageData[i] >= thresh)
			img->imageData[i] = 255;
		else
			img->imageData[i] = 0;
		//////////////////////////////////
	}

	////////////////////////////////////////

	//first find where the edge begins
	int i = 0;
	while ((unsigned char)img->imageData[i] > 0) {
		i++;
	}
	int pos = i;
	//////////////////////////////////

	int count = 0;
	int B = imgW;

	unsigned char *pic = imgData; // placeholder for image data
	int randx[MAX_RAND], randy[MAX_RAND];
	int rimx[MAX_RAND], rimy[MAX_RAND];

	int newpos, local_tresh = 100, draw_type;
	draw_type = 0;
	newpos = pos; // pos equals the starting position in the image ( = y*Width + x)
	while (newpos >= 0L && newpos < imgSize)
	{
		rimx[count] = newpos % B; // save current position in list
		rimy[count] = newpos / B;
		count++;
		draw_type = (draw_type + 3) % 4; // Select next search direction
		switch (draw_type)
		{
		case 0: if (pic[newpos + 1] > local_tresh) { newpos += 1; draw_type = 0; break; }
		case 1: if (pic[newpos + B] > local_tresh) { newpos += B; draw_type = 1; break; }
		case 2: if (pic[newpos - 1] > local_tresh) { newpos -= 1; draw_type = 2; break; }
		case 3: if (pic[newpos - B] > local_tresh) { newpos -= B; draw_type = 3; break; }
		case 4: if (pic[newpos + 1] > local_tresh) { newpos += 1; draw_type = 0; break; }
		case 5: if (pic[newpos + B] > local_tresh) { newpos += B; draw_type = 1; break; }
		case 6: if (pic[newpos - 1] > local_tresh) { newpos -= 1; draw_type = 2; break; }
		case 7: if (pic[newpos - B] > local_tresh) { newpos -= B; draw_type = 3; break; }
		}
		// If we are back at the beginning, we declare success
		if (newpos == pos)
			break;
		// Abort if the contour is too complex.
		if (count >= MAX_RAND)
			break;
	}
	/////////////////////////////////////////////////////

	for (int i = 0; i < imgW*imgH; i++) {
		copy->imageData[i] = 255;
	}
	////////////////////////DRAW THE EDGE ON THE ORIGINAL
	for (int i = 0; i < MAX_RAND; i++) {
		if (rimx[i] != 0 && rimy[i] != 0) {
			img->imageData[rimx[i] + rimy[i] * imgW] = 100;
			copy->imageData[rimx[i] + rimy[i] * imgW] = 0;
		}
	}
	///////////////////////////////////////////////////



	while (1) {
		cvShowImage("My image", img);
		cvShowImage("Rim", copy);
		if (cvWaitKey(5) > 0)
			break;
	};
	return 0;
}