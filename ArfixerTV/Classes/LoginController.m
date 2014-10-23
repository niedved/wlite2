

#import "LoginController.h"
#import "AppDelegate.h"

@interface LoginController()

@end

@implementation LoginController

- (void)viewDidLoad
{
    hide = NO;
    [super viewDidLoad];
    UIColor* bgcolor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fb_bg.jpg"]];
    [self.view setBackgroundColor:bgcolor];
    [self hideStatusBar];
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


- (void)facebookSessionStateChanged:(FBSession *)session state:(FBSessionState)state error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen:
            // handle successful login here
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            [FBSession.activeSession closeAndClearTokenInformation];
            
            if (error) {
                // handle error here, for example by showing an alert to the user
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Could not login with Facebook"
                                                                message:@"Facebook login failed. Please check your Facebook settings on your phone."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
            break;
        default:
            break;
    }
}

    
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    FBLoginView *loginView =
    [[FBLoginView alloc] initWithReadPermissions:
     @[@"public_profile", @"email",  @"user_friends", @"publish_actions"]];
    loginView.delegate = self;
    loginView.center = CGPointMake(self.view.center.y, self.view.center.x);
    [self.view addSubview:loginView];
    
    if ( hide ){
        [self performSelector:@selector(dissmis) withObject:nil afterDelay:0.0];
    }
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    if ( !hide ){
        AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate setLogIn:YES];
        [appDelegate setUserData:user];
        hide = YES;
        
        NSMutableArray* friendsFBidsArray = [[NSMutableArray alloc] init];
        
        FBRequest* friendsRequest = [FBRequest requestForMyFriends];
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      NSDictionary* result,
                                                      NSError *error) {
            NSArray* _friends = [[NSArray alloc] init];;
            _friends = [result objectForKey:@"data"];
            appDelegate->friends = _friends;
            for (NSDictionary* fr in _friends) {
                
                [friendsFBidsArray addObject:[fr objectForKey:@"id"]];
            }
            NSString* joinedFriendsfbids = [friendsFBidsArray componentsJoinedByString:@","];
            DBController* dbc = [[DBController alloc] init];
            NSLog(@"email of user: %@", [user objectForKey:@"id"] );
            [dbc setUserFriendsByFbIds:[user objectForKey:@"id"] friendsfbids:joinedFriendsfbids];
            NSLog(@"friends fbid: %@", joinedFriendsfbids);
            
        }];
        
        
        
        [self performSelector:@selector(dissmis) withObject:nil afterDelay:0.0];
    }
}

-(void)dissmis{
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate->app_status = 4;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// Logged-in user experience
//- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
//    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [appDelegate setLogIn:YES];
//    hide = YES;
//    
//}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setLogIn:NO];
    hide = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
