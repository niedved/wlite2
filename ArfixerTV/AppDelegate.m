//
//  AppDelegate.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 12.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    pageControl.backgroundColor = [UIColor colorWithRed:40/255.0 green:185/255.0 blue:154/255.0 alpha:0.4];
    
    is_loged = NO;
    app_status = 0;
    
    self.oDBC = [[DBController alloc] init];
    
    [self reloadAppSettings];
    NSLog(@"settings: %@", settings );
    
    int _mu_id = [[self getMuId] intValue];
    if ( _mu_id > 0 ){
        
    }
    else{
        NSDictionary* amuid = [self.oDBC reserveMuId];
        [self setMuId:[amuid objectForKey:@"mu_id"]];
    }
    
    [self reloadMobilePoints];
    [self.oDBC addLog:[[self getMuId] intValue] action:0 geo_long:0 geo_lat:0 p1:@"" p2:@""];
    
    
    self.last_location = nil;
    _CLController = [[CoreLocationController alloc] init];
    _CLController.delegate = self;
    [_CLController.locMgr startUpdatingLocation];
    
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationType)(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    
//    NSString* msg = [NSString stringWithFormat:@"Launch with no push"];
    
//    NSDictionary* userInfo =
//    [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
//    if (userInfo) {
//        NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
//        
//        NSString *alertMsg = @"";
//        NSString *badge = @"";
//        NSString *sound = @"";
//        NSString *custom = @"";
//        
//        if( [apsInfo objectForKey:@"alert"] != NULL)
//        {
//            alertMsg = [apsInfo objectForKey:@"alert"];
//        }
//        
//        
//        if( [apsInfo objectForKey:@"badge"] != NULL)
//        {
//            badge = [apsInfo objectForKey:@"badge"];
//        }
//        
//        
//        if( [apsInfo objectForKey:@"sound"] != NULL)
//        {
//            sound = [apsInfo objectForKey:@"sound"]; 
//        }
//        
//        if( [userInfo objectForKey:@"Custom"] != NULL)
//        {
//            custom = [userInfo objectForKey:@"Custom"];
//        }
//      
//        forced_topic_id = [badge intValue];
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"kForcedTopic" object:nil];
//        
//    }
//    else{
//        forced_topic_id = 0;
//    }
    
    
    
//    forced_topic_id = 6;
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kForcedTopic" object:nil];
//    
//        // TODO: Pull the poke's info from our server and update the UI to display it
//    NSLog( @"forced_topic_id: %d", forced_topic_id);
//    
//
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"push"
//                                                    message:msg
//                                                   delegate:nil
//                                          cancelButtonTitle:@"OK"
//                                          otherButtonTitles:nil];
//    [alert show];
    
    
    
    return YES;
}

-(void)reloadAppSettings{
    settings = [[NSMutableDictionary alloc] init];
   NSDictionary* sets = [self.oDBC getAppSettings];
    for (NSDictionary* setdet in sets) {
        [settings setObject:[setdet objectForKey:@"value"] forKey:[setdet objectForKey:@"name"]];
    }
}

-(void)reloadMobilePoints{
    NSDictionary* muserpoints = [self.oDBC getMobilePoints:[[self getMuId] intValue]];
    points_mobile = [[muserpoints objectForKey:@"points"] intValue];
    points_user = [[muserpoints objectForKey:@"pointsSum"] intValue];
    points_success = [[muserpoints objectForKey:@"pointsTarget"] intValue];
}

-(BOOL)checkIsLogedIn{
    return is_loged;
}
-(void)setLogIn:(BOOL)loged{
    is_loged = loged;
}

-(void)setUserData: (id<FBGraphUser>)user{
    self.userInfo = [[NSMutableDictionary alloc] init];
    [self.userInfo setObject:[NSString stringWithFormat:@"%@",user.id] forKey:@"fbid"];
    [self.userInfo setObject:[NSString stringWithFormat:@"%@",user.name] forKey:@"name"];
    [self.userInfo setObject:[user objectForKey:@"email"] forKey:@"email"];
    
    //check czy juz nie istnieje
    NSDictionary* amuid = [self.oDBC saveUserEmailToDB:[[self getMuId] intValue]  email:[self.userInfo objectForKey:@"email"]
                            name:[self.userInfo objectForKey:@"name"]
                            first_name:[self.userInfo objectForKey:@"first_name"]
                            last_name:[self.userInfo objectForKey:@"last_name"]
                            fbid:[self.userInfo objectForKey:@"fbid"]
                            gender:[self.userInfo objectForKey:@"gender"]
     ];
 
    NSLog(@"setUSerDataEnd: %@", amuid);
    [self setMuId:[amuid objectForKey:@"mu_id"]];
    [self.oDBC addLog:
     [[amuid objectForKey:@"mu_id"] intValue] action:1
             geo_long:self.last_location.coordinate.longitude
              geo_lat:self.last_location.coordinate.latitude p1:@"" p2:@""];
    
    
    
}

-(NSMutableDictionary*) getUserData{
    return self.userInfo;
}



-(void)setMuId: (NSNumber*)_mu_id{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:_mu_id forKey:@"mu_id"];
    [prefs synchronize];
}

-(NSString*)getMuId{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* _mu_id = [prefs stringForKey:@"mu_id"];
    return _mu_id;
}
-(void)setLastScan{
    NSLog(@"setLastScan");
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSDate *now = [NSDate date];
    [prefs setObject:[NSString stringWithFormat:@"%f", [now timeIntervalSince1970]] forKey:@"lastScanTime"];
    [prefs synchronize];
    NSLog(@"setLastScan: %f %f", [now timeIntervalSince1970], [self getLastScan]);
    
    
       
}
-(double)getLastScan{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString* lastScanTime = [prefs stringForKey:@"lastScanTime"];
    return [lastScanTime doubleValue];
}


- (void)locationUpdate:(CLLocation *)location {
    
    CLLocationDistance meters = [location distanceFromLocation:self.last_location];
    self.last_location = location;
    if( meters > 20.0 || meters < 0 ){
        [self.oDBC addLog:[[self getMuId] intValue] action:2 geo_long:location.coordinate.longitude geo_lat:location.coordinate.latitude p1:@"" p2:@""];
        [_CLController.locMgr stopUpdatingLocation];
    }
    
}

- (void)locationError:(NSError *)error {
    NSLog(@"locationError: %@", [error description] );
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:  (NSString *)sourceApplication annotation:(id)annotation
{
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication  fallbackHandler:^(FBAppCall *call)
            {
                NSLog(@"Facebook handler");
            }
            ];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppEvents activateApp];
    [FBAppCall handleDidBecomeActive];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [FBSession.activeSession close];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"devToken=%@",deviceToken);
    NSString *deviceToken2 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken2 = [deviceToken2 stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self.oDBC setMobileUserToken:[[self getMuId] intValue] token:deviceToken2];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSLog(@"Error in registration. Error: %@", err);
}




@end
