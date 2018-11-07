#pragma once


class Calibration {
public:
	int imgHeight = 0;
	int imgWidth = 0;
	float pix_pr_mm_x = 0;
	float pix_pr_mm_y = 0;
	
	float tempintrinsicMatrix[3][3] = {
		{0, 0, 0},
		{0, 0, 0},
		{0, 0, 1}
	};

	CvMat* intrinsicMatrix;
	CvMat* distortionCoefficients;
	
	float focal_length_mm = 0;

	void initCameraParams(float fx, float  fy, float  s, float  cx, float  cy, float  k1, float  k2, float  k3, float  p1, float  p2, int imageWidth, int imageHeight, float pixprmmx, float pixprmmy) {
		imgHeight = imageHeight;
		imgWidth = imageWidth;

		intrinsicMatrix = cvCreateMat(3, 3, CV_32FC1);
		distortionCoefficients = cvCreateMat(1, 5, CV_32FC1);

		tempintrinsicMatrix[0][0] = fx;
		tempintrinsicMatrix[1][1] = fy;
		tempintrinsicMatrix[0][1] = s;
		tempintrinsicMatrix[0][2] = cx;
		tempintrinsicMatrix[1][2] = cy;

		cvSetData(intrinsicMatrix, tempintrinsicMatrix, 5*3);

		float inputDistCoeff[5] = { k1, k2, p1, p2, k3};

		cvSetData(distortionCoefficients, inputDistCoeff, 4*5);

		pix_pr_mm_x = pixprmmx;
		pix_pr_mm_y = pixprmmy;

		//focal lengt calculatet as the average of the one in x-pixels and the one in y pixels
		focal_length_mm = (fx / pix_pr_mm_x + fy / pix_pr_mm_y) / 2;
	}
};