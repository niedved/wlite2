//
//  ARFast.h
//  watchato
//
//  Created by Marcin Niedźwiecki on 07.08.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>


using namespace cv;

@interface ARFast : NSObject{
    
    @public
    int lastFrameTres;
}




+(int) FAST3M:(cv::Mat&)src_img  src_kp:(std::vector<cv::KeyPoint>&)src_keypoints initTres:(int)initial_threshold desire_kp:(int)desired_kp_count delta:(int) delta kpCountTarget:(int)kpCountTarget;
+(bool)operacjaSprawdzZlozonosc:(Mat&)imagex grayFrameAfterCuts:(Mat&)grayFrameAfterCuts mintreshold:(int)mintreshold kpsnomargin:(vector<KeyPoint>&)kpsnomargin kpCountTarget:(int)kpCountTarget  initTres:(int&)initTres;

@end
