//
//  HistoryTableViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "ChatTableViewController.h"
#import "ChatTopicTableViewCell.h"
#import "ChatMsgTableViewController.h"
#import "DBController.h"
#import "AppDelegate.h"

@interface ChatTableViewController ()

@end

@implementation ChatTableViewController
{
    NSArray *recipes;
    int clicked_topic_id;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hideStatusBar];
}

-(void)viewDidAppear:(BOOL)animated{
    NSUInteger index = [self.tabBarController.tabBar.items indexOfObject:self.tabBarController.tabBar.selectedItem];
    NSLog(@"index: %lu", index );
    [self reloadDatas: index];
}

-(void)reloadDatas: (long)select{
    DBController* DBC = [[DBController alloc] init];
    AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ( select == 1 ){
        recipes = (NSArray*)[DBC getUserTopics:[[appDel getMuId] intValue] lastHours:72];
    }
    else{
        recipes = [[NSArray alloc] init];
        recipes = (NSArray*)[DBC getUserFirendsTopics:[[appDel getMuId] intValue] lastHours:72];
    }
    [self.tableView reloadData];
}

-(void)changeSelector:(id)sender{
    UISegmentedControl *uisc = (UISegmentedControl*)sender;
//    [self.segmentC setSelectedSegmentIndex:uisc.selectedSegmentIndex];
//    self.segmentC.selectedSegmentIndex = 1;
    NSLog(@"usic: %ld", (long)uisc.selectedSegmentIndex );
    [self reloadDatas:(long)uisc.selectedSegmentIndex ];
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
    
    NSString* nibName = @"ChatTopicTableViewCell";
    ChatTopicTableViewCell* cell;
    cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:nibName bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    }
    
    NSDictionary* rowdata = [recipes objectAtIndex:indexPath.row];
    
    
    cell.labelData.text = [NSString stringWithFormat:@"%@ - %@", [rowdata objectForKey:@"nick"], [rowdata objectForKey:@"date"]];
    cell.labelOne.text = [NSString stringWithFormat:@"%@ - %@",
                          [rowdata objectForKey:@"channel"],
                          [rowdata objectForKey:@"program_name"]];
    
    cell.labelTwo.text = [NSString stringWithFormat:@"%@", [rowdata objectForKey:@"topic"]];
    
    if ( [rowdata objectForKey:@"port"] == [NSNull null] ){
        cell.image.image = [UIImage imageNamed:@"logo.png"];
    }
    else{
        cell.image.image = [UIImage imageNamed:[NSString stringWithFormat:@"logo%d.png",[[rowdata objectForKey:@"port"] intValue] ]];
    }
    
    return cell;
    
    
//    
//    static NSString *simpleTableIdentifier = @"SimpleTableCell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
////    bleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    
//    NSDictionary* rowdata = [recipes objectAtIndex:indexPath.row];
//    
////    cell.textLabel.text = [NSString stringWithFormat:@"%@",[rowdata objectForKey:@"program_name"] ];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@",[rowdata objectForKey:@"topic"]];
//    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [rowdata objectForKey:@"nick"], [rowdata objectForKey:@"date"]];
//    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
//    
//    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"logo%d.png",[[rowdata objectForKey:@"port"] intValue] ]];
//
//
//    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    clicked_topic_id = [[[recipes objectAtIndex:indexPath.row] objectForKey:@"chat_id"] intValue];
//    [self performSegueWithIdentifier:@"showMsg" sender:self];
    ChatMsgTableViewController *vcToPushTo = [[ChatMsgTableViewController alloc] init];
    vcToPushTo->topic_id = clicked_topic_id;

    [self presentViewController:vcToPushTo animated:YES completion:nil];
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 2, tableView.frame.size.width, 36)];
    /* Create custom view to display section header... */
//    40 185 154
    [view setBackgroundColor:[UIColor colorWithRed:40/255.0 green:185/255.0 blue:154/255.0 alpha:1.0]];
    return view;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    ChatMsgTableViewController *vcToPushTo = [segue destinationViewController];
    vcToPushTo->topic_id = clicked_topic_id;
}


@end
