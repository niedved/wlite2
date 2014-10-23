//
//  LogsController.m
//  Opolgraf
//
//  Created by Marcin Niedźwiecki on 21.06.2012.
//  Copyright (c) 2012 XCITY Game Development Studio. All rights reserved.
//

#import "LogsController.h"
#import "DBController.h"

@implementation LogsController


//
////metoda zapisuje posx i posy w tabeli z user_info i ustawia parametry posx posy kalsy logow
//-(void)savePushToken :(NSString*)user_id :(NSString*)token{
//    
//    NSString* url_string = [NSString stringWithFormat:@"http://ygd13959497c.nazwa.pl/ar_opolgraf/index.php/ajax/Common/UserInfo/actualize_user_token?u_id=%@&token=%@", user_id,token];
//    NSLog(@"savePushToken: %@", url_string );
//    [self getResponseFromPostHTML:url_string];
//}
//
//
//
////metoda zapisuje posx i posy w tabeli z user_info i ustawia parametry posx posy kalsy logow
//-(void)saveGPS :(NSString*)user_id :(double)_posx :(double)_posy{
//    
//    posx = _posx;
//    posy = _posy;
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString* _user_id = [prefs stringForKey:@"log_phone_id"];
//    
//    if (! gpsSaved ){
//        NSString* url_string = [NSString stringWithFormat:@"http://ygd13959497c.nazwa.pl/ar_opolgraf/index.php/ajax/Common/UserInfo/actualize_user_location?u_id=%@&posx=%f&posy=%f", _user_id, _posx, _posy ];
////        [self getResponseFromPostHTML:url_string];
//        gpsSaved = true;
//    }
//    //
//}
//
//-(void)addLogAtButtonPressed :(NSString*)user_id tracker_id:(NSString*)tracker_id button_id:(NSString*)button_id 
//                             button_type:(NSString*)button_type
//{
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString* _user_id = [prefs stringForKey:@"log_phone_id"];
//    
//    NSLog(@"addLogAtButtonPressed id:%@ t: %@", button_id, button_type );
//    [self getResponseFromPostHTML:
//     [self prepareArLogUrlWithUserId:_user_id
//                        log_type:LOG_TYPE_BUTTON track_id:tracker_id button_id:button_id button_type:button_type]
//     ];
//}
//
//
//
////nie odpaalmy bo to zamuli
//-(void)addLogAtTracked :(NSString*)user_id :(NSString*)tracker_id
//{
//    NSLog(@"addLogAtTracked");
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    NSString* _user_id = [prefs stringForKey:@"log_phone_id"];
//   
//    
//    [self getResponseFromPostHTML:
//     [self prepareArLogUrlWithUserId:_user_id log_type:LOG_TYPE_TRACKABLE track_id:tracker_id button_id:0 button_type:0]
//     ];
//}


//-(void)addLogAtLaunch :(int)user_id {
//    DBController* DB = [[DBController alloc] init];
//    [DB addLog:user_id action:0 param1:@"0" param2:@"0"];
//}

//
//-(NSString*)prepareArLogUrlWithUserId :(NSString*)u_id 
//                              log_type:(int)log_type track_id:(NSString*)track_id 
//                                button_id:(NSString*)button_id button_type:(NSString*)button_type
//{
//    NSString* url_string = [NSString stringWithFormat:URL_ADD_LOG, u_id, log_type, track_id, APP_ID, posx, posy, button_id, button_type];
//    return url_string;
//}
//
//
//
//-(NSString*)newUserSaveLogAndGetLogUserId
//{
//    NSLog(@"newUserSaveLogAndGetLogUserId");
//    NSString* url_string = [NSString stringWithFormat:@"http://ygd13959497c.nazwa.pl/ar_opolgraf/index.php/ajax/Common/UserInfo/save_new_user_log" ];
//    NSString* responseString = [self getResponseFromPostHTML:url_string];
//    NSLog(@"response: %@", responseString );
////    return @"";
//    return responseString;
//}
//
//
//-(NSString*)getResponseFromPostHTML :(NSString*)url_string {
////    NSLog(@"sendPostHTML: %@", url_string);
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSURL *url2 = [NSURL URLWithString:url_string];
//    //    NSLog(@"BO saveTag(): %@", content );
//    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
//    [request2 setHTTPMethod:@"POST"];
//    
//    NSHTTPURLResponse  *response2 = nil;
//    NSError *error2 = nil;
//    NSData *responseData2;
//    responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
//    NSString *responseString = 
//    [[[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding] autorelease];
//    
//    if ([response2 statusCode] == 200 && error2 == nil) {
//        return responseString;     
//    }
//    else{
//        return nil;
//    }
//    [pool release];
//}
//
//-(NSData*)getResponseDataFromPostHTML :(NSString*)url_string {
//    //    NSLog(@"sendPostHTML: %@", url_string);
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSURL *url2 = [NSURL URLWithString:url_string];
//    //    NSLog(@"BO saveTag(): %@", content );
//    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
//    [request2 setHTTPMethod:@"POST"];
//    
//    NSHTTPURLResponse  *response2 = nil;
//    NSError *error2 = nil;
//    NSData *responseData2;
//    responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
////    NSString *responseString =
////    [[[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding] autorelease];
//    
//    if ([response2 statusCode] == 200 && error2 == nil) {
//        return responseData2;
//    }
//    else{
//        return nil;
//    }
//    [pool release];
//}




@end
