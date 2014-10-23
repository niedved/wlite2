//
//  PointViewControllerViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 26.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointViewControllerViewController : UIViewController{
    
    @public
    int pointsAdded;
    int canal_id;
    int status;
    NSDictionary* canals;
    NSDictionary* program;
}


@property (weak, nonatomic) IBOutlet UIButton *s_fb;
@property (weak, nonatomic) IBOutlet UIButton *s_tw;
@property (weak, nonatomic) IBOutlet UIButton *hideButton;
@property (weak, nonatomic) IBOutlet UILabel *labelCanalName;
@property (weak, nonatomic) IBOutlet UILabel *labelProgramName;
@property (strong, nonatomic) IBOutlet UIProgressView *progessProgram;
@property (weak, nonatomic) IBOutlet UILabel *labelProgramStart;
@property (weak, nonatomic) IBOutlet UILabel *labelProgramEnd;
@property (weak, nonatomic) IBOutlet UILabel *labelPointsGained;
@property (weak, nonatomic) IBOutlet UILabel *labelShareIt;


- (IBAction)hidePointView:(id)sender;
-(IBAction)shareFB:(id)sender;

-(IBAction)shareTw:(id)sender;
-(IBAction)startDiscuion:(id)sender;
@end
