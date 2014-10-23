//
//  ViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 12.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "ViewController.h"
#import "PointViewControllerViewController.h"
#import "ChatMsgTableViewController.h"


@implementation ViewController
@synthesize imageView;

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(forcedTopicView) name:@"kForcedTopic" object:nil];
    
    self.topView.layer.borderWidth = 0.0;
    self.bottomView.layer.borderWidth = 0.0;
    appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self hideStatusBar];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
    
    oARFLive = [[ARFLive alloc] initWithImageView:self.imageView frame_max_counter:3*25];
    oARFLive.bottomLabel = self.bottomLabel;
    oARFLive.progressView = self.progressView;
    [oARFLive cameraAutofocus:YES];
    [oARFLive setROI:celownik.frame];
    
    
    double value = [self.stepper value];
//    AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
//    appDel->delaySekundy = value;
    [self.stepperLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
    
    
    [self ogarnijCanalsStatus];
    
    if ( appDel->forced_topic_id > 0  ){
        [self forcedTopicView];
    }
    
}

-(void)forcedTopicView{
    NSLog(@"forcedTopicView");
    ChatMsgTableViewController *vcToPushTo = [[ChatMsgTableViewController alloc] init];
    vcToPushTo->topic_id = appDel->forced_topic_id;
    appDel->forced_topic_id = 0;
    [self presentViewController:vcToPushTo animated:YES completion:nil];
    
}

-(UIImageView*)getCorrectCanalIconView:(int)canal_id{
    switch (canal_id) {
        case 15: return self.canal0; break;
        case 7: return self.canal1; break;
        case 101: return self.canal2; break;
        case 1: return self.canal3; break;
        case 5: return self.canal4; break;
        case 3: return self.canal5; break;
        case 20: return self.canal6; break;
        
        case 21: return self.canal7; break;
        case 23: return self.canal8; break;
        case 26: return self.canal9; break;
//        case 26: return self.canal10; break;
//        case 23: return self.canal11; break;
//        case 2024: return self.canal12; break;
//        case 2025: return self.canal13; break;
//        case 2026: return self.canal14; break;
//        case 2027: return self.canal15; break;
            
        default:
            return self.canal0;
            break;
    }
}

-(void)ogarnijCanalsStatus{
    NSThread* myThread = [[NSThread alloc] initWithTarget:self
                                                 selector:@selector(ogarnijCanalsStatusN)
                                                   object:nil];
    [myThread start];  // Actually create the thread
}


-(void)ogarnijCanalsStatusN{
    NSDictionary* canalsstate = [appDel.oDBC getCanalsStatus];
    int num=0;
    float alfaOnline = 1.0;
    float alfaOffline = 0.25;
    
    for (NSDictionary* info in canalsstate) {
        NSLog(@"info: %@", [info objectForKey:@"canal_id"] );
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"logo%@",[info objectForKey:@"canal_id"]]];
        UIImageView* iv = [self getCorrectCanalIconView:[[info objectForKey:@"canal_id"] intValue]];
        [iv setImage:image];
        iv.layer.borderWidth = 1.0f;
//        NSLog(@"%lld .. %lld", [self gettime:[info objectForKey:@"current_time"]], [self gettime:[info objectForKey:@"lasttime"]]);
        
        
        if ( [self gettime:[info objectForKey:@"current_time"]] - [self gettime:[info objectForKey:@"lasttime"]] <= 5 ){
            [iv setAlpha:alfaOnline];
        }
        else{
            [iv setAlpha:alfaOffline];
        }
        //0.35
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(ogarnijCanalsStatus)
                                   userInfo:nil
                                    repeats:NO];
    
    
    
}

-(long long) gettime: (NSString*)mysqldatetime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:mysqldatetime];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *numericString = [formatter stringFromDate:date];
    long long current_time = [numericString longLongValue];
    return current_time;
}

-(void) handleTap: (UITapGestureRecognizer*) gestureRecognizer{
    NSLog(@"TAPED!!!!!");
    [oARFLive startGatheringFrames];
}

- (IBAction)showTutorial:(id)sender{
    [self performSelector:@selector(showTutorialModal) withObject:nil afterDelay:0.0];
}

- (IBAction)valueChanged:(UIStepper *)sender {
    double value = [sender value];
    oARFLive->delaySekundy = value;
    
    [self.stepperLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
}


-(void)hideStatusBar{
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]){
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else{
        //ios 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)kontrolujARFLIVE{
    
    if ( oARFLive->istniejeNowyWynik ){
        NSLog(@"SHOW TABLICE Z INFORMACJA O PROGRAMIE: %lu", oARFLive->ostatniWynik);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"<your date format goes here"];
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM/dd/yyyy hh:mma"];
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
        NSInteger hour = [components hour];
//        NSInteger minute = [components minute];
        
        int points = 0;
        if ( hour >= 0 && hour <= 7){
            points = arc4random() % 10;
        }
        else if ( hour >= 8 && hour <= 11){
            points = (arc4random() % 10)+10;
        }
        else if ( hour >= 12 && hour <= 16){
            points = (arc4random() % 30)+20;
        }
        else if ( hour >= 17 && hour <= 20){
            points = (arc4random() % 80) + 20;
        }
        else{
            points = (arc4random() % 80) + 20;
        }
        
        PointViewControllerViewController* pcvc = [[PointViewControllerViewController alloc] initWithNibName:@"PointViewControllerViewController" bundle:nil];
        pcvc->canal_id = (int)oARFLive->ostatniWynik;
        pcvc->pointsAdded = points;
        
        [appDel setLastScan];
        
        [self presentViewController:pcvc animated:YES completion:nil];
        
        oARFLive->istniejeNowyWynik = NO;
    };
}


-(void)ogarnijTimeToScan{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    double lastTimeScan = [appDelegate getLastScan];
    NSDate *now = [NSDate date];
//    NSLog(@"set: %f - (%f-%f)", [[appDel->settings objectForKey:@"scan_interval_time"] floatValue], [now timeIntervalSince1970], lastTimeScan );
    float timeleft =[[appDel->settings objectForKey:@"scan_interval_time"] floatValue] - ( [now timeIntervalSince1970] - lastTimeScan );
//    NSLog( @"ogarnijTimeToScan: %f", timeleft );
    int min = floor(timeleft / 60);
    int sec =  (int)timeleft - (min*60);
    min = ( min < 0 ) ? 0 :min;
    sec = ( sec < 0 ) ? 0 :sec;
    
    
    NSString* minS = ( min < 10 ) ?
    [NSString stringWithFormat:@"0%d", min] :[NSString stringWithFormat:@"%d",min];
    NSString* secS = ( sec < 10 ) ?
    [NSString stringWithFormat:@"0%d", sec] :[NSString stringWithFormat:@"%d",sec];
    
    
    [self.timerToNextScan setText:[NSString stringWithFormat:@"%@:%@", minS, secS]];
}

-(void) ogarnijPunkty{
    [self.targetpointsLabel setText:[NSString stringWithFormat:@"%d", appDel->points_success] ];
    [self.userpointsLabel setText:[NSString stringWithFormat:@"(%d)%d /", appDel->points_mobile, appDel->points_user ]];
}

-(void) ogarnijInfoOUserze{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"appDelegate.userInfo: %@", appDelegate.userInfo);
    if ( [[appDelegate.userInfo objectForKey:@"fbid"] length] ){
        NSString *deviceType = [UIDevice currentDevice].model;
        
        CGRect icoRect;
        NSLog(@"deviceType: %@", deviceType );
        if([deviceType isEqualToString:@"iPhone"]){
            icoRect = CGRectMake(5, 2, 20, 20);
        }
        else{
            icoRect = CGRectMake(20, 4, 90, 90);
        }
        
        FBProfilePictureView *profileImage = [[FBProfilePictureView alloc] initWithFrame:icoRect];
        profileImage.profileID = [appDelegate.userInfo objectForKey:@"fbid"];
        [self.view addSubview:profileImage];
        profileImage.layer.borderWidth = 1.0;
        profileImage.layer.borderColor = [UIColor blackColor].CGColor;
        [self.userName setText: [appDelegate.userInfo objectForKey:@"name"] ];
    }
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    switch (appDelegate->app_status){
        case 0:
            if( YES )
                [self performSelector:@selector(showTutorialModal) withObject:nil afterDelay:0.0];
            else
                appDelegate->app_status = 1;
            
            break;
        case 2:
            [self performSelector:@selector(showLoginModal) withObject:nil afterDelay:0.0];
            break;
        case 4:
            NSLog(@"PORA NA APKE");
            break;
        default: NSLog(@"HMMMM");
            break;
    }
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ogarnijTimeToScan) userInfo:nil repeats:YES];
    timerWynik = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(kontrolujARFLIVE) userInfo:nil repeats:YES];
    
    
    [self ogarnijInfoOUserze];
    [self ogarnijPunkty];
}


- (void)showTutorialModal
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->app_status = 1;
    TutorialViewController* tutorialVC = [[TutorialViewController alloc] init];
    [self presentViewController:tutorialVC animated:YES completion:nil];
}

- (void)showLoginModal
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->app_status = 3;
    LoginController* loginVC = [[LoginController alloc] init];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
