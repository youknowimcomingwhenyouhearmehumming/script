// opencv_helloworld.cpp : Defines the entry point for the consoleapplication.
#include <stdio.h>
#include "cv.h"
#include "cxcore.h"
#include "highgui.h"
#include <conio.h>
int main(int argc, char* argv[])
{
	const char* wName = "Hello world!"; // window name
	cvNamedWindow(wName, 0); // create simple window
	CvCapture* capture = 0;
	double capProp = 0;
	IplImage *frame, *frame_copy = 0; // pointers to images
	capture = cvCaptureFromCAM(0); // initialize capture device

	frame = cvRetrieveFrame(capture);
	printf("Frame settings:\n Width: %d\n Height: %d\n", frame->width, frame->height);
	frame_copy = cvCreateImage(cvSize(frame->width, frame->height), IPL_DEPTH_8U, frame->nChannels);
	cvResizeWindow(wName, frame->width, frame->height);
	cvSaveImage("test.jpg", frame_copy, 0);
	cvFlip(frame, frame_copy, 0);
	cvShowImage(wName, frame_copy);

	cvReleaseImage(&frame_copy);
	printf("finish");
	cvDestroyWindow("Hello World");
	return 0;
}



//	if (capture)
//	{
//		for (;;)
//		{
//			if (!cvGrabFrame(capture))
//				break;
//				printf("Grab");
//			frame = cvRetrieveFrame(capture);
//			printf("cv retricer");
//
//			if (!frame)
//				break;
//			if (!frame_copy)
//			{
//				printf("Frame settings:\n Width: %d\n Height: %d\n",frame->width, frame->height);
//				frame_copy = cvCreateImage(cvSize(frame->width, frame -> height), IPL_DEPTH_8U, frame->nChannels);
//				cvSaveImage("test.jpg", frame_copy, 0);
//
//				cvResizeWindow(wName, frame->width, frame->height);
//				printf("frame_copy done");
//
//
//			}
//			if (frame->origin == IPL_ORIGIN_TL)
//				cvCopy(frame, frame_copy, 0);
//			else
//				cvFlip(frame, frame_copy, 0);
//				printf("else");
//
//			cvShowImage(wName, frame_copy);
//			printf("else done");
//
//			if (cvWaitKey(5) > 0)
//				break;
//		}
//	}
//
//	
//
//	cvReleaseImage(&frame_copy);
//	printf("fonish");
//	cvDestroyWindow("Hello World");
//	return 0;
//}
//


