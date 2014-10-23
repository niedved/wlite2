//
//  AppDelegate.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 12.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DBController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CoreLocationController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, CoreLocationControllerDelegate>{
    int is_loged;
    @public
    int app_status;
    double delaySekundy;
    int lastscantime;
    
    int mu_id;
    int points_mobile;
    int points_user;
    int points_success;
    int forced_topic_id;
    int scan_time_interval_sec;
    NSMutableDictionary* settings;
    NSArray* friends;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImage *firstImage;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) DBController *oDBC;
@property (strong, nonatomic) CoreLocationController *CLController;
@property (nonatomic, strong, readwrite) CLLocation *last_location;

-(void)setLogIn:(BOOL)loged;
-(void)setUserData: (id<FBGraphUser>)user;
-(void)setMuId: (NSNumber*)mu_id;
-(NSString*)getMuId;
-(void)setLastScan;
-(void)reloadMobilePoints;
-(double)getLastScan;
-(NSMutableDictionary*) getUserData;


    
@end
