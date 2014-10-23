//
//  LogsController.h
//
//  Created by Marcin Niedźwiecki on 21.06.2012.
//  Copyright (c) 2012 XCITY Game Development Studio. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface DBController : NSObject{
    
}

-(NSDictionary*)reserveMuId;
-(NSDictionary*)getMobilePoints:(int)mu_id;
-(NSDictionary*)getUserPoints:(int)mu_id;
-(NSDictionary*)getAppSettings;

-(NSDictionary*)addNewTopic:(int)mu_id msg:(NSString*)msg prog_id:(int)prog_id;
-(NSDictionary*)addMsgToTopic:(int)mu_id msg:(NSString*)msg topic_id:(int)topic_id;
-(NSDictionary*)getUserTopics:(int)mu_id lastHours:(int)lastHours;
-(NSDictionary*)getUserFirendsTopics:(int)mu_id lastHours:(int)lastHours;
-(NSDictionary*)addUserPoints:(int)mu_id pointadd:(int)pointadd;
-(NSDictionary*)getCanalsStatus;

-(NSDictionary*)getMsgsByTopicId:(int)topic_id;

-(NSDictionary*)saveUserEmailToDB :(int)mu_id  email:(NSString*)email name:(NSString*)name first_name:(NSString*)first_name last_name:(NSString*)last_name fbid:(NSString*)fbid gender:(NSString*)gender;
-(NSDictionary*)addLog :(int)mu_id action:(int)action_id geo_long:(float)geo_long geo_lat:(float)geo_lat p1:(NSString*)p1 p2:(NSString*)p2;
-(NSDictionary*)setMobileUserToken :(int)mu_id token:(NSString*)token;
-(NSDictionary*)getCanalProgramInfo:(int)canal_id time:(long)time;

-(NSDictionary*)getUserHistoryByEmail:(NSString*)email hours:(int)hours;

-(NSDictionary*)getUserHistoryByFBID:(NSString*)fbid hours:(int)hours;

-(NSDictionary*)setUserFriendsByFbIds: (NSString*)userfbid friendsfbids:(NSString*)friendsfbids;

//-(NSDictionary*)getPagesForIshue :(int)ishue_id;
//-(NSDictionary*)getButtonsForIshue :(int)ishue_id;
//-(NSDictionary*)getSettingsForIshue :(int)ishue_id;
//-(NSDictionary*)getButtonsForPages :(NSString*)pages;
//-(NSDictionary*)getIshuesForAppId :(int)app_id;
//-(NSDictionary*)getPageFilesForIssue: (int)issue_id;
//-(NSDictionary*)getMobileUser :(int)mu_id;

@end
