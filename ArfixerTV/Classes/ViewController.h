//
//  ViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 12.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialViewController.h"
#import "LoginController.h"
#import "AppDelegate.h"

#import <opencv2/highgui/cap_ios.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>

#import "ARFLive.h"

using namespace cv;


@interface ViewController : UIViewController{
    IBOutlet UIImageView *imageView;
    NSTimer* timer;
    NSTimer* timerWynik;
    BOOL proceed_with_operation;
    int time_to_end;
    
    AppDelegate* appDel;
    
    ARFLive* oARFLive;
    
    IBOutlet UIImageView *celownik;
    
}


@property (nonatomic, retain) CvVideoCamera* videoCamera;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *userpointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetpointsLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *timerToNextScan;
@property (weak, nonatomic) IBOutlet UIImageView *canal0, *canal1,*canal2,*canal3,*canal4,*canal5,*canal6;
@property (weak, nonatomic) IBOutlet UIImageView *canal7, *canal8,*canal9,*canal10,*canal11,*canal12,*canal13;
@property (weak, nonatomic) IBOutlet UIStepper* stepper;
@property (weak, nonatomic) IBOutlet UILabel* stepperLabel;

- (IBAction)showTutorial:(id)sender;
-(void)forcedTopicView;

@end