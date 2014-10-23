//
//  ViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 12.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface TutorialContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *imageFile;

- (IBAction)closeTutorial:(id)sender;


@end
