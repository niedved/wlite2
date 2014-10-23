//
//  LogsController.h
//  Opolgraf
//
//  Created by Marcin Niedźwiecki on 21.06.2012.
//  Copyright (c) 2012 XCITY Game Development Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

enum _logType {
    LOG_TYPE_LAUNCH = 0,
    LOG_TYPE_TRACKABLE = 10,
    LOG_TYPE_BUTTON = 20,
};

const static int APP_ID = 6;
static NSString* URL_ADD_LOG = 
@"http://ygd13959497c.nazwa.pl/ar_opolgraf/index.php/ajax/Common/ArLogs/dodaj_log?u_id=%@&type=%i&trackable_id=%@&app_id=%d&posx=%f&posy=%f&button_id=%@&button_type=%@";

@interface LogsController : NSObject
{
    bool gpsSaved;
    double posx, posy;
}

//-(NSDictionary*)getAppSetup;
//-(void)savePushToken :(NSString*)user_id :(NSString*)token;
//-(void)saveGPS :(NSString*)user_id :(double)_posx :(double)_posy;
//-(void)addLogAtButtonPressed :(NSString*)user_id tracker_id:(NSString*)tracker_id button_id:(NSString*)button_id
//                  button_type:(NSString*)button_type;
//-(void)addLogAtTracked :(NSString*)user_id :(NSString*)tracker_id;
//-(void)addLogAtLaunch :(int)user_id;
//-(NSString*)newUserSaveLogAndGetLogUserId;
//-(NSDictionary*)getMsgsByTopicId:(int)topic_id;
@end
