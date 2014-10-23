//
//  LogsController.m
//
//  Created by Marcin Niedźwiecki on 21.06.2012.
//  Copyright (c) 2012 XCITY Game Development Studio. All rights reserved.
//

//#import "SBJson.h"
#import "DBController.h"


NSString* CMS_URL = @"http://arfixer.eu/tv_cms/mobile.php";

@implementation DBController

-(NSDictionary*)reserveMuId {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/User/reserveMuId", CMS_URL ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)setUserFriends: (NSString*)usermail friendsmails:(NSString*)friendsmails {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/User/setUserFriends?usermail=%@&friendsmails=%@", CMS_URL, usermail, friendsmails ];
    return [self getReturnData:url_string];
}
-(NSDictionary*)setUserFriendsByFbIds: (NSString*)userfbid friendsfbids:(NSString*)friendsfbids {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/User/setUserFriendsByFbIds?userfbid=%@&friendsfbids=%@", CMS_URL, userfbid, friendsfbids ];
    return [self getReturnData:url_string];
}


-(NSDictionary*)getMobilePoints:(int)mu_id {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/UserPoints/getMobilePoints?mu_id=%d", CMS_URL, mu_id ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)getCanalProgramInfo:(int)canal_id time:(long)time {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Program/currentData?port=%d&time=%ld", CMS_URL, canal_id, time ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)getUserHistoryByEmail:(NSString*)email hours:(int)hours {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Logs/getHistoryByMail?lastHours=%d&email=%@", CMS_URL, hours, email ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)getUserHistoryByFBID:(NSString*)fbid hours:(int)hours {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Logs/getHistoryByFbId?lastHours=%d&fbId=%@", CMS_URL, hours, fbid ];
    return [self getReturnData:url_string];
}


-(NSDictionary*)getUserPoints:(int)mu_id {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/UserPoints/getUserPoints?mu_id=%d", CMS_URL, mu_id ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)getCanalsStatus {
    NSString* url_string = [NSString stringWithFormat:@"http://217.173.202.179:8080/vr/canalStatus.php?verbose=0"];
    return [self getReturnData:url_string];
}



-(NSDictionary*)addNewTopic:(int)mu_id msg:(NSString*)msg prog_id:(int)prog_id{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Chat/startTopic?msg=%@&mu_id=%d&prog_id=%d", CMS_URL, msg, mu_id, prog_id ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)addMsgToTopic:(int)mu_id msg:(NSString*)msg topic_id:(int)topic_id{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Chat/sendMsgToChat?msg=%@&mu_id=%d&topic_id=%d", CMS_URL, msg, mu_id, topic_id ];
    return [self getReturnData:url_string];
}


-(NSDictionary*)getUserTopics:(int)mu_id lastHours:(int)lastHours{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Chat/getTopicsByMuId?mu_id=%d", CMS_URL, mu_id ];
    return [self getReturnData:url_string];
}
-(NSDictionary*)getUserFirendsTopics:(int)mu_id lastHours:(int)lastHours{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Chat/getFriendsTopics?mu_id=%d", CMS_URL, mu_id ];
    return [self getReturnData:url_string];
    
}
-(NSDictionary*)getMsgsByTopicId:(int)topic_id{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Chat/getMsgsByTopicId?topic_id=%d", CMS_URL, topic_id ];
    return [self getReturnData:url_string];
    
}



-(NSDictionary*)addUserPoints:(int)mu_id pointadd:(int)pointadd {
//    http://arfixer.eu/tv_cms/mobile.php/ajax/Common/UserPoints/addPoint?mu_id=2&points=23
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/UserPoints/addPoint?mu_id=%d&points=%d", CMS_URL, mu_id, pointadd ];
    return [self getReturnData:url_string];
}

-(NSDictionary*)getAppSettings {
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/ApplicationSettings/getAppSettings", CMS_URL ];
    return [self getReturnData:url_string];
}


-(NSDictionary*)saveUserEmailToDB:(int)mu_id email:(NSString*)email name:(NSString*)name first_name:(NSString*)first_name last_name:(NSString*)last_name fbid:(NSString*)fbid gender:(NSString*)gender {
    NSString* url_string =
    [NSString stringWithFormat:@"%@/ajax/Common/User/createNewAccount?mu_id=%d&nick=%@&name=%@&surname=%@&email=%@&password=nopass&fbid=%@&gender=%@", CMS_URL , mu_id, name, first_name, last_name, email, fbid, gender ];
    NSLog(@"saveUserEmailToDB: %@", url_string);
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                                     JSONObjectWithData: data//1
                                     options:kNilOptions
                                     error:&error2];
    
    
    return returnDataDict;
}


-(NSDictionary*)addLog :(int)mu_id action:(int)action_id geo_long:(float)geo_long geo_lat:(float)geo_lat p1:(NSString*)p1 p2:(NSString*)p2
{
    NSLog(@"addLog");
    
    NSString* url_string =
        [NSString stringWithFormat:
         @"%@/ajax/Common/Logs/addLog?mu_id=%d&log_type_id=%d&geo_long=%.2f&geo_lat=%.2f&spec1=%@&spec2=%@",
         CMS_URL , mu_id, action_id, geo_long, geo_lat, p1, p2 ];
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                           JSONObjectWithData: data//1
                           options:kNilOptions
                           error:&error2];
    
    return returnDataDict;
}


-(NSDictionary*)setMobileUserToken :(int)mu_id token:(NSString*)token{
    NSLog(@"setMobileUserToken");
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/User/setTokenForUser?mu_id=%d&token=%@", CMS_URL , mu_id, token ];
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                                     JSONObjectWithData: data//1
                                     options:kNilOptions
                                     error:&error2];
    
    return returnDataDict;
    
}






-(NSDictionary*)getButtonsForPages :(NSString*)pages
{
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/Ishue/_mobileGetPagesButtons?pages=%@", CMS_URL , pages ];
    NSLog(@"getButtonsForPages: %@", url_string);
    
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                                     JSONObjectWithData: data//1
                                     options:kNilOptions
                                     error:&error2];
    
    return returnDataDict;
}




-(NSDictionary*)getMobileUser :(int)mu_id{
    NSLog(@"getMobileUser");
    NSString* url_string = [NSString stringWithFormat:@"%@/ajax/Common/MobileUsers/getUserOrCreateNewOne?mu_id=%d", CMS_URL , mu_id ];
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                                     JSONObjectWithData: data//1
                                     options:kNilOptions
                                     error:&error2];
    
    return returnDataDict;
    
}



-(NSDictionary*) getReturnData:(NSString*) url_string {
    NSData* data = [self getResponseDataFromPostHTML:url_string];
    NSError *error2 = nil;
    NSDictionary* returnDataDict =  [NSJSONSerialization
                                     JSONObjectWithData: data//1
                                     options:kNilOptions
                                     error:&error2];
    
    return returnDataDict;
}

-(NSData*)getResponseDataFromPostHTML :(NSString*)url_string {
    
    url_string = [url_string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSLog(@"sendPostHTML: %@", url_string);
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *url2 = [NSURL URLWithString:url_string];
    //    NSLog(@"BO saveTag(): %@", content );
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse  *response2 = nil;
    NSError *error2 = nil;
    NSData *responseData2;
    responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
      NSString *responseString =
        [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
    
    NSLog(@"error: %@", error2 );
    NSLog(@"response: %@", responseString );
    if ([response2 statusCode] == 200 && error2 == nil) {
        return responseData2;
    }
    else{
        return nil;
    }
//    [pool release];
}






@end
