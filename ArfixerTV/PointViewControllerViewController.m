//
//  PointViewControllerViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 26.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "PointViewControllerViewController.h"
#import "DBController.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <Twitter/TWTweetComposeViewController.h>
#import "ChatMsgSendViewController.h"
#import <Accounts/Accounts.h>

#import "STTwitterAPI.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@interface PointViewControllerViewController ()

@property (nonatomic, strong) ACAccountStore *accountStore;

@end

@implementation PointViewControllerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _accountStore = [[ACAccountStore alloc] init];
        
        [self hideStatusBar];
    }
    return self;
}

//

- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    NSLog(@"postImage");
//    
//    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:@"6VtEcd9pcnPktMQTNiQsnw1EH"
//                                        consumerSecret:@"rDJBGUbXKaSa8bKZnCowLVUpzZZw1d7R5SkEYaBUfskHncKnXc"
//                                                                username:@"ARFixer"
//                                                                password:@"NoProblem007"];
    
    
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}



-(IBAction)shareTw:(id)sender{
//-(void)shareIt{
    NSArray *activityItems;
  
    AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    activityItems = @[@"Hi there. See what is currently watching.", appDel.firstImage ];
    
    
//    self.view.modalView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.75f];
    //    STabBarControler* sttab = (STabBarControler*)appDelegate.viewController.tabBarController;
    //    [sttab hideIt];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:activityItems
                                                    applicationActivities:nil];
    
    [activityController setCompletionHandler:^(NSString *activityType, BOOL done){
        if (done) {
            NSLog(@"Success");
        }
        else {
            NSLog(@"Error/Cancel");
        }
        
    }];
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")){
        
        activityController.popoverPresentationController.sourceView = self.view;
    }
    
    
    [self presentViewController:activityController
                                      animated:YES completion:nil];
    
    
}


//
//-(IBAction)shareTw:(id)sender{
//    UIImage* img = [UIImage imageNamed:@"logo2008"];
//    [self postImage:img withStatus:@"testowe post"];
//    
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
//        
//        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        
//        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
//            if (result == SLComposeViewControllerResultCancelled) {
//                
//                NSLog(@"Cancelled");
//                
//            } else
//                
//            {
//                NSLog(@"Done");
//            }
//            
//            [controller dismissViewControllerAnimated:YES completion:Nil];
//        };
//        controller.completionHandler =myBlock;
//        
//        //Adding the Text to the facebook post value from iOS
//        [controller setInitialText:@"User is currently watching TV and gathering points with APPNAME"];
//        
//        //Adding the URL to the facebook post value from iOS
//        
//        [controller addURL:[NSURL URLWithString:@"http://www.arfixer.com"]];
//        
//        //Adding the Image to the facebook post value from iOS
//        
//        [controller addImage:[UIImage imageNamed:[NSString stringWithFormat:@"logo%d.png", canal_id]]];
//        
//        [self presentViewController:controller animated:YES completion:Nil];
//        
//    }
//    else{
//        NSLog(@"UnAvailable");
//    }
//    
//}

//
//-(IBAction)shareFB:(id)sender{
//    NSArray *activityItems;
//    activityItems = @[@"Test test just test", [UIImage imageNamed:@"arfixer logo"] ];
////    appDelegate.viewController.modalView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75f];
//    
//    UIActivityViewController *activityController = [[UIActivityViewController alloc]
//                                                    initWithActivityItems:activityItems
//                                                    applicationActivities:nil];
//    
//    [activityController setCompletionHandler:^(NSString *activityType, BOOL done){
//        if (done) {
//            NSLog(@"Success");
//        }
//        else {
//            NSLog(@"Error/Cancel");
//        }
//        
//    }];
//    
//    
//    [self presentViewController:activityController
//                                             animated:YES completion:nil];
//    
//    
//}
//
//



-(IBAction)startDiscuion:(id)sender{
//    [self postImage:[UIImage imageNamed:@"response48.png"] withStatus:@"testowe post"];
    ChatMsgSendViewController* msgVC = [[ChatMsgSendViewController alloc] init];
    msgVC.newTopic = YES;
    if ( [program objectForKey:@"prog_id"] == [NSNull null]){
        msgVC.prog_id = 0;
        NSLog(@"program: %d", 0 );
        
    }
    else{
        NSLog(@"program: %d", [[program objectForKey:@"prog_id"] intValue] );
        msgVC.prog_id = [[program objectForKey:@"prog_id"] intValue];
    }
    [self presentViewController:msgVC animated:YES completion:nil];
}


-(IBAction)shareFB:(id)sender{

    // Check if the Facebook app is installed and we can present the share dialog
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    params.link = [NSURL URLWithString:@"https://http://arfixer.com/"];
//    params.name = @"Testssss";
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
        NSLog(@"OK");
        // Present share dialog
        [FBDialogs presentShareDialogWithLink:params.link
                                      handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
    } else {
        // Present the feed dialog
        NSLog(@"CANNOT");
    }
    
    
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

-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"pointsAdded: %d",pointsAdded);
    [super viewDidAppear:animated];
//    [self.labelProgramStart
    canals = @{@"2027":@"TVP ROZRYWKA",@"26":@"TVP POLONIA",
                             @"25":@"TVP OPOLE",@"24":@"TVP KULTURA",
                             @"23":@"TVP INFO",@"22":@"TVP HISTORIA",
                             @"21":@"TVP2 HD",@"20":@"TVP1 HD",
                             @"17":@"TVP1",@"16":@"TVP ABC",@"15":@"ESKA TV",
                             @"14":@"TVP ABC",@"13":@"TVP1",@"12":@"TVP ABC",
                             @"11":@"TVP1",@"10":@"TVP ABC",@"7":@"Polsat",
                             @"6":@"TV Puls2",@"5":@"TV4",@"4":@"Polsat Sport News",
                             @"3":@"TV6",@"2":@"TV Puls",@"1":@"TVN7",@"101":@"TVN"};
    
    
    [self.labelCanalName setText:[canals objectForKey:[NSString stringWithFormat:@"%d", canal_id]]];
    DBController* dbc = [[DBController alloc] init];
    NSDate* data = [NSDate date];
//    [data timeIntervalSince1970]
    program = [dbc getCanalProgramInfo:canal_id time:[data timeIntervalSince1970]];
//    if ( status == 2 ){
//        [self.labelPointsGained setText:[NSString stringWithFormat:@"You win. Congratulations!!"]];
//        [self.labelShareIt setText:@"Share it and check Your email!"];
//        
//    }
//    else if ( status == 3 ){
        [self.labelPointsGained setText:[NSString stringWithFormat:@"Unfortunately exceeded the number of points."]];
        [self.labelShareIt setText:@"watchato about it with friends !"];
        
//    }
//    else{
//        [self.labelPointsGained setText:[NSString stringWithFormat:@"+ %d", pointsAdded]];
//        [self.labelShareIt setText:@"watchato about it with friends !"];
//    }
    [self.labelProgramName setText:[program objectForKey:@"program_name"]];
    [self.labelProgramStart setText:[program objectForKey:@"startTime"]];
    [self.labelProgramEnd setText:[program objectForKey:@"endTime"]];
    
    [self.progessProgram setProgress:[[program objectForKey:@"proc"] floatValue] animated:YES];
    
    AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [dbc addLog:
     [[appDel getMuId] intValue] action:3
             geo_long:appDel.last_location.coordinate.longitude
              geo_lat:appDel.last_location.coordinate.latitude p1:[NSString stringWithFormat:@"%d", canal_id] p2:[program objectForKey:@"prog_id"]];

    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Do any additional setup after loading the view, typically from a nib.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError* error) {
        
        ACAccount *account = [[ACAccount alloc] initWithAccountType:accountType];
        NSLog(@"%@, %@", account.username, account.description);
    }];

    
    
}


- (IBAction)hidePointView:(id)sender{
    AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDel reloadMobilePoints];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
