//
//  ChatLeftTableViewCell.h
//  ArfixerTV
//
//  Created by Marcin Niedźwiecki on 05.06.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatTopicTableViewCell : UITableViewCell{
    
}

@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIView *cloudView;
@property (weak, nonatomic) IBOutlet UILabel *labelOne;
@property (weak, nonatomic) IBOutlet UILabel *labelTwo;
@property (weak, nonatomic) IBOutlet UILabel *labelData;

@end
