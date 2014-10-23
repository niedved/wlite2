//
//  HistoryTableViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    
    NSArray* friends;
}

@end
