//
//  ChatMsgSendViewController.m
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 05.06.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "ChatMsgSendViewController.h"
#import "DBController.h"
#import "AppDelegate.h"


@interface ChatMsgSendViewController ()

@end

@implementation ChatMsgSendViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.newTopic = NO;
        self.topic_id = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.textArea.delegate = self;
    [self.textArea.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.textArea.layer setBorderWidth:1.0f];
    [self.textArea.layer setCornerRadius:5];
    
    if ( self.newTopic ){
        [self.topbarTopic setTitle:@"Start new discussion"];
    }
    else{
        [self.topbarTopic setTitle:@"Join the discussion"];
        NSLog(@"topicid: %d", self.topic_id );
    }
    
    // Do any additional setup after loading the view from its nib.
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





- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Return pressed: is new topic:%d", self.newTopic);
        DBController* DBC = [[DBController alloc] init];
        AppDelegate* appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if ( self.newTopic )
            [DBC addNewTopic:[[appDel getMuId] intValue]msg:textView.text prog_id:self.prog_id];
        else
            [DBC addMsgToTopic:[[appDel getMuId] intValue]msg:textView.text topic_id:self.topic_id];
        
        [textView resignFirstResponder];
        textView.editable = NO;
        //SEND
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    } else {
        NSLog(@"Other pressed");
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)flag {
    [super viewWillAppear:flag];
    [self.textArea setText:@""];
    [self.textArea becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
