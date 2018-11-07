#include "cxcore.h"
#include "highgui.h"
#include <stdio.h>
#include "cv.h"
#include <conio.h>
#include <math.h>

#include "opencv.hpp"
#include "opencv2/core/core_c.h"
#include "opencv2/imgproc/types_c.h"
#include <math.h>
#include <string.h>

#include "Calibration.h"

void main(void) {
	float fx = 908.921733151973;
	float fy = 995.247731365519;
	float s = -15.8121588308052;
	float cx = 690.612007494641;
	float cy = 461.163209321290;
	float k1 = -0.195200486160091;
	float k2 = 1.44309320026758;
	float k3 = -2.54469713898683;
	float p1 = -0.0436772602775102;
	float p2 = 0.0275603618902545;
	int imageWidth = 1280;
	int imageHeight = 720;
	float pixprmmx = 100;
	float pixprmmy = 100;

	char* filePath1 = "testimg.jpg";
	IplImage* img1 = cvLoadImage(filePath1, CV_LOAD_IMAGE_GRAYSCALE);
	cvNamedWindow("Image 1", CV_WINDOW_AUTOSIZE); // create simple window

	//Initiate the calibration parameters to be used through the code
	Calibration CalibrationParams;
	CalibrationParams.initCameraParams(fx, fy, s, cx, cy, k1, k2, k3, p1, p2, imageWidth, imageHeight, pixprmmx, pixprmmy);

	//Create undistorted image by undistort image
	IplImage* img_undistorted = cvCreateImage(cvSize(CalibrationParams.imgWidth, CalibrationParams.imgHeight), 8, 1);
	cvNamedWindow("Image undistorted", CV_WINDOW_AUTOSIZE);


	//cvUndistort2(img1, img_undistorted, intrinsic, inputCoeff);
	cvUndistort2(img1, img_undistorted, CalibrationParams.intrinsicMatrix, CalibrationParams.distortionCoefficients);
	
	//Create undistorted image by undistort points




	while (1) {
		cvShowImage("Image 1", img1);
		cvShowImage("Image undistorted", img_undistorted);
		if (cvWaitKey(5) > 0)
			break;
	};
}