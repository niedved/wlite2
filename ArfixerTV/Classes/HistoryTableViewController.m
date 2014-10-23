//
//  HistoryTableViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "HistoryTableViewController.h"
#import "DBController.h"
#import "AppDelegate.h"

@interface HistoryTableViewController ()

@end

@implementation HistoryTableViewController
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self reloadDatas: 0];
    
    [self getAllMyFBFriends];
    
    [self hideStatusBar];
}

-(void)reloadDatas: (BOOL)select{
    DBController* DBC = [[DBController alloc] init];
    if ( select == 0 ){
        
        AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        NSLog(@"sdfdsfsd: %@",  );
        recipes = (NSArray*)[DBC getUserHistoryByEmail:[appDel.userInfo objectForKey:@"email"] hours:24];
    }
    else{
        recipes = [[NSArray alloc] init];
        for (NSDictionary<FBGraphUser>* friend in friends) {
            NSLog(@"I have a friend named %@ with id %@", friend.name, friend.id);
            NSMutableArray* x = (NSMutableArray*)[DBC getUserHistoryByFBID:friend.id hours:24];
            NSMutableArray * xx = [[NSMutableArray alloc] init];
            //add imie nazwisko do receipes[timestamp]
            for (NSMutableDictionary* log in x) {
                NSString* newVal = [NSString stringWithFormat:@"%@ - %@", [log objectForKey:@"timestamp"], friend.name ];
                NSMutableDictionary* xxm = [[NSMutableDictionary alloc] initWithDictionary:log copyItems:YES];
                [xxm setValue:newVal forKey:@"timestamp"];
                [xx addObject:xxm];
            }
            recipes = [recipes arrayByAddingObjectsFromArray:xx];
            
        }
    }
    [self.tableView reloadData];
}


-(void)getAllMyFBFriends{
//    NSLog(@"getAllMyFBFriends: %@", FBSession.activeSession.permissions );
    
    FBRequest* friendsRequest = [FBRequest requestForMyFriends];
    [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                  NSDictionary* result,
                                                  NSError *error) {
//        NSLog(@"%@", result );
        friends = [result objectForKey:@"data"];
    }];
    
}

-(IBAction)changeSelector:(id)sender{
    UISegmentedControl *uisc = (UISegmentedControl*)sender;
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
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    bleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    
    NSDictionary* rowdata = [recipes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[rowdata objectForKey:@"program_name"] ];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13.0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [rowdata objectForKey:@"timestamp"]];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"logo%d.png",[[rowdata objectForKey:@"port"] intValue] ]];

    
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
