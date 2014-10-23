//
//  HistoryTableViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "ChatMsgTableViewController.h"
#import "ChatLeftTableViewCell.h"
#import "ChatRightTableViewCell.h"
#import "ChatMsgSendViewController.h"
#import "DBController.h"
#import "AppDelegate.h"

@interface ChatMsgTableViewController ()
    


@end

@implementation ChatMsgTableViewController
{
    NSArray *recipes;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)hideChatMsg{
        [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    last_autor_mu_id = 0;
    isleft = NO;
//    [self reloadDatas: 0];
    
    [self hideStatusBar];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
}

-(void) responseMsg{
    NSLog(@"responseMsg");
    ChatMsgSendViewController* msgVC = [[ChatMsgSendViewController alloc] init];
    msgVC.topic_id = topic_id;
    
    [self presentViewController:msgVC animated:YES completion:nil];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    float largerDimension = rect.size.width  > rect.size.height ?
    rect.size.width : rect.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 36)];
    /* Create custom view to display section header... */
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(largerDimension/2-90, 2, 200, 36)];
    [label setFont:[UIFont boldSystemFontOfSize:12]];
    NSString *string =@"WATCHATO - discussion";
    /* Section header is in 0th index... */
    [label setText:string];
    
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    
    UIButton* closeButton = [[UIButton alloc] initWithFrame:CGRectMake(4, 2, 36, 36)];
    [closeButton setImage:[UIImage imageNamed:@"back64"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(hideChatMsg) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeButton];
    [view bringSubviewToFront:closeButton];
    
    
    
    UIButton* responseButton = [[UIButton alloc] initWithFrame:CGRectMake(largerDimension-40, 2, 36, 36)];

    [responseButton setImage:[UIImage imageNamed:@"response48"] forState:UIControlStateNormal];
    [responseButton addTarget:self action:@selector(responseMsg) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:responseButton];
    [view bringSubviewToFront:responseButton];
    
//    self.tableView.tableHeaderView = view;

    
    
    return view;
}




-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"topic: %d", topic_id );
    [self reloadDatas: 0];
}


-(void)reloadDatas: (BOOL)select{
    DBController* DBC = [[DBController alloc] init];
    if ( select == 0 ){
        recipes = (NSArray*)[DBC getMsgsByTopicId:topic_id];
    }
    
   
    [self.tableView reloadData];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}
 */


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [recipes count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    
    static NSString *simpleTableIdentifier = @"myCell";
    
    NSString* nibName = @"ChatLeftTableViewCell";
    ChatRightTableViewCell* cell;
    
    NSDictionary* rowdata = [recipes objectAtIndex:indexPath.row];
    
    if ( last_autor_mu_id != [[rowdata objectForKey:@"mu_id"] intValue] ){
        isleft = !isleft;
    }
    last_autor_mu_id = [[rowdata objectForKey:@"mu_id"] intValue];
    
    
    
    if( isleft ){
        nibName = @"ChatRightTableViewCell";
        simpleTableIdentifier = @"myCellRight";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
    }
    else{
        nibName = @"ChatLeftTableViewCell";
        simpleTableIdentifier = @"myCellLeft";
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    
   if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    
    
    cell.labelOne.text = [NSString stringWithFormat:@"%@ - %@", [rowdata objectForKey:@"nick"], [rowdata objectForKey:@"date"]];
    cell.labelTwo.text = [NSString stringWithFormat:@"%@", [rowdata objectForKey:@"msg"]];
    

FBProfilePictureView *profileImage =
    [[FBProfilePictureView alloc]
        initWithFrame:CGRectMake(0, 0,cell.image.frame.size.width, cell.image.frame.size.height)];
profileImage.profileID = [rowdata objectForKey:@"fbid"];
[cell.image addSubview:profileImage];
profileImage.layer.borderWidth = 1.0;
profileImage.layer.borderColor = [UIColor blackColor].CGColor;


//    [cell.image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"logo2000.png" ]]];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
