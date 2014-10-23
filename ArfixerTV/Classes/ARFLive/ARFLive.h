//
//  SRFLive.h
//  ArfixerTV
//
//  Created by ARFixer on 19.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <opencv2/highgui/cap_ios.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>

#import "ARFHuges.h"
#import "ARFast.h"
#import "AppDelegate.h"

using namespace cv;

@interface ARFLive : NSObject<CvVideoCameraDelegate>{
    CvVideoCamera* videoCamera;
    bool proceed_with_operation;
    int time_to_end;
    
    ARFHuges* arfhuges;
    AppDelegate* appDelegate;

    
    vector<Mat> frame_container;
    double _t0 , _t1, _t_first_touch;
    int frame_max_counter;
    CGRect ROIimageView;
    CGRect RectOfImageView;
    
    
    
    //zmienne for method
    double tab_of_mean[100];
    double tab_of_kp[100];
    double tab_of_kp_top[100];
    double tab_of_kp_bottom[100];
    double tab_of_kp_left[100];
    double tab_of_kp_right[100];
    double tab_of_q[100];
    double tab_of_q_str[100];
    double tab_of_qll[100];
    double tab_of_qll_str[100];
    double tab_of_ql[100];
    double tab_of_ql_str[100];
    double tab_of_qh[100];
    double tab_of_qh_str[100];
    double tab_of_qhh[100];
    double tab_of_qhh_str[100];
    double tab_of_qc[100];
    double tab_of_qc_str[100];
    double tab_of_color_b[100];
    double tab_of_color_g[100];
    double tab_of_color_r[100];
    double tab_of_color_qb[100];
    double tab_of_color_qg[100];
    double tab_of_color_qr[100];
    double tab_of_color_qb_str[100];
    double tab_of_color_qg_str[100];
    double tab_of_color_qr_str[100];
    double tab_of_hsv_h_lr[100];
    double tab_of_hsv_h_tb[100];
    double tab_of_hsv_b[100];
    double tab_of_hsv_g[100];
    double tab_of_hsv_r[100];
    double tab_of_hsv_q[100];
    double tab_of_hsv_q1[100];
    double tab_of_hsv_q2[100];
    double tab_of_hsv_q3[100];
    double tab_of_hsv_q4[100];
    string tab_of_hsv_cells[100];
    string tab_of_ascii[100];
    long long tab_of_szachownicakp[100];
    Mat twoframes[2];
    
@public
    bool istniejeNowyWynik;
    long ostatniWynik;
    NSString* ostatniWynikName;
    int licznik_zapisanych_klatek;
    int licznik_sprawdzonych_klatek;
    
    int lastFrameTresholdInit;
    double delaySekundy;
    
    NSString* sendData;
}


@property int kpCountTarget;
@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (weak, nonatomic) UILabel *bottomLabel;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIView *wynikView;



-(void)prepareForTriangles: (Mat&)colframe frameNum: (int)frameNum;
-(id)initWithImageView:(UIImageView*)imageView frame_max_counter:(int)_frame_max_counter;
-(void)cameraAutofocus :(BOOL)autofocus;
-(void)startGatheringFrames;
-(void)setROI: (CGRect)rect;
@end
