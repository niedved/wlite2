//
//  HistoryTableViewController.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 27.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTableViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* friends;
}

@property UISegmentedControl* segmentC;

@end
