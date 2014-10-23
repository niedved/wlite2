//
//  HistoryTableViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMsgTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    
    @public
    int topic_id;
    int last_autor_mu_id;
    bool isleft;
}

-(void)hideChatMsg;

@end
