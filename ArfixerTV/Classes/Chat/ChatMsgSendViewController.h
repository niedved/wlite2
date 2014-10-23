//
//  ChatMsgSendViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 05.06.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMsgSendViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textArea;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBack;
@property BOOL newTopic;
@property (weak, nonatomic) IBOutlet UINavigationBar *topbarNavBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *topbarTopic;
@property int prog_id;
@property int topic_id;
- (IBAction)goBackAction:(id)sender;

@end
