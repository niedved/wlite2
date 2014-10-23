//
//  SRFLive.m
//  ArfixerTV
//
//  Created by ARFixer on 19.05.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import "ARFLive.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@implementation ARFLive
@synthesize videoCamera, bottomLabel;


-(id)initWithImageView:(UIImageView*)imageView frame_max_counter:(int)_frame_max_counter{
//    [super init];
    self.kpCountTarget = 250;
    arfhuges = [[ARFHuges alloc] init];
    
//    return self;
    frame_max_counter = _frame_max_counter;
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:imageView];
    self.videoCamera.delegate = self;
    //    self.videoCamera.sess
    self.videoCamera.defaultAVCaptureDevicePosition =
    AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset =
    AVCaptureSessionPreset1280x720;
    
    self.videoCamera.defaultFPS = 25;
    [self.videoCamera start];
    
    
    ROIimageView = imageView.frame;
    RectOfImageView = imageView.frame;
    
    istniejeNowyWynik = NO;
    appDelegate = [[UIApplication sharedApplication] delegate];
    
    
    return self;
}

-(void)setROI: (CGRect)rect{
    ROIimageView = rect;
}


-(void)cameraAutofocus :(BOOL)autofocus{
    AVCaptureDevice *cameraDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // SETUP FOCUS MODE
    if ([cameraDevice lockForConfiguration:nil]) {
        if ( autofocus )
            [cameraDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        else
            [cameraDevice setFocusMode:AVCaptureFocusModeLocked];
        [cameraDevice unlockForConfiguration];
    }
    else{
        NSLog(@"error while configuring focusMode");
    }
}


#ifdef __cplusplus
- (void)processImage:(Mat&)imagex
{
    [self capture100ConvertPart: imagex];
}



vector<Mat> frame_container;
double _t0 , _t1, _t_first_touch;



-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat2
{
    Mat cvMat;
    cvtColor(cvMat2, cvMat, COLOR_RGB2BGRA);
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}



-(bool)processA:(Mat&)imagex{
    //kliknelismy start
    bool firstest = YES;
    if ( proceed_with_operation ){
        
        if ( time_to_end == frame_max_counter ){
            _t0 = [[NSDate date] timeIntervalSince1970];
            firstest = YES;
            frame_container.clear();
            
            NSLog(@"START");
        }
        else{
            firstest = NO;
        }
        
        if ( time_to_end-- <=0 ){
            proceed_with_operation = NO;
            NSLog(@"KONIEC");
            [self.bottomLabel performSelectorOnMainThread:@selector(setText:)withObject:@"FOCUS ON TV & TAP SCREEN" waitUntilDone:NO];
            [self cameraAutofocus:YES];
            _t1 = [[NSDate date] timeIntervalSince1970];
            NSLog(@"--> gromadzenie klatek klatek time: %f", _t1 - _t0 );
            return true;
            
        }
        else
        {
            UIScreen* scr = [UIScreen mainScreen];
            float largerI = RectOfImageView.size.width > RectOfImageView.size.height ?
            RectOfImageView.size.width : RectOfImageView.size.height;
            float largerC = ROIimageView.size.width > ROIimageView.size.height ?
            ROIimageView.size.width : ROIimageView.size.height;
            
            float proc = largerC / largerI;
            int width = imagex.rows * proc;
            int height = imagex.cols * proc;
            cv::Mat subImg;
            imagex(cv::Rect( (int)(1280-height)/2 , (int)(720-width)/2, height, width)).copyTo(subImg);
            
            if ( firstest ){
                vector<KeyPoint> kps;
                cv::Mat grayframe;
                cvtColor(subImg, grayframe, COLOR_RGB2GRAY);
                cv::FAST(grayframe, kps, 40);
                if (kps.size() < 30 ) {
                    [self.bottomLabel performSelectorOnMainThread:@selector(setText:)withObject:@"OCZEKIWANIE NA OSTROŚĆ LUB BARDZIEJ ZŁOŻONĄ SCENE" waitUntilDone:NO];
                    NSLog(@"START NO ?: %lu", kps.size()  );
                    time_to_end++;
                    return false;
                }
                else{
                    //lock focus ??
                   [self.bottomLabel performSelectorOnMainThread:@selector(setText:)withObject:@"GROMADZENIE KLATEK - MAX 5 Sek." waitUntilDone:NO];
                    NSLog(@"START TAK ?: %lu", kps.size()  );
                    _t_first_touch = [[NSDate date] timeIntervalSince1970];
                    Mat xxx = subImg.clone();
                    frame_container.push_back(xxx);
                    appDelegate.firstImage = [self UIImageFromCVMat:xxx];
//                    AppDelegate
//                    firstImage
                    return false;
                }
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressView setProgress:(float)((float)time_to_end/(float)frame_max_counter)];
                });
                Mat xxx = subImg.clone();
                int numer = frame_max_counter - time_to_end - 1;
                if( numer%6 == 0 ){
                    frame_container.push_back(xxx);
                }
                return false;
            }
        }
    }
    return false;
}


-(void)startGatheringFrames{
    [self.wynikView removeFromSuperview];
    NSLog(@"startGatheringFrames");
    time_to_end = frame_max_counter;
    proceed_with_operation = YES;
}



-(NSString*)przyogotujStringDoEchaKey: (NSString*)key iend:(int)iend endprzec:(bool)endprzec tab_of:(double[100])tab_of empty:(bool)empty{
    NSString* combinedStuff = [NSString stringWithFormat: @"\"%@\":", key];
    if ( !empty ){
        combinedStuff = [NSString stringWithFormat:@"%@[", combinedStuff];
        for (int c=0; c<iend; c++) {
            combinedStuff = [NSString stringWithFormat:@"%@%.0f,", combinedStuff, tab_of[c]];
        }
        combinedStuff = [NSString stringWithFormat:@"%@]", combinedStuff];
    }
    else{
        combinedStuff = [NSString stringWithFormat:@"%@[]", combinedStuff];
    }
    if ( endprzec )
        combinedStuff = [NSString stringWithFormat:@"%@,", combinedStuff];
    
    return combinedStuff;
}


-(void)prepareForTriangles: (Mat&)colframe frameNum: (int)frameNum{
    //REMOVED FOR LITE
}

-(BOOL)checkMinKPInAllFrames: (int)minkpcount{
    //test kp very small
    bool datasok = YES;
    float sum = 0;
    for (int c=0; c<=25; c++) {
        sum += tab_of_kp[c];
    }
    NSLog(@"suma kp we wszystkich frames: %f", sum );
    if ( sum < minkpcount ){
        [self.bottomLabel performSelectorOnMainThread:@selector(setText:)withObject:@"FOCUS ON TV & TAP SCREEN" waitUntilDone:NO];
        datasok = NO;
        
        if(![NSThread isMainThread])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView1 = [[UIAlertView alloc] initWithTitle:@"Debug score" message:@"Za mało danych. Spróbuj ponownie." delegate:self cancelButtonTitle:@"Hide" otherButtonTitles: nil];
                alertView1.alertViewStyle = UIAlertViewStyleDefault;
                [alertView1 setTag:555];
                [alertView1 show];
            });
        }
    }
    
    return datasok;
}





-(NSString*) przygotujDaneZTabelNaPotrzebyLinku{
    NSString * combinedStuff = @"";
    combinedStuff = [NSString stringWithFormat:@"{"];
    
    combinedStuff = [NSString stringWithFormat:@"%@%@",
                     combinedStuff,
                     [self przyogotujStringDoEchaKey:@"q" iend:25
                            endprzec:YES tab_of:tab_of_kp empty:NO]];
    
    combinedStuff = [NSString stringWithFormat:@"%@\"%@\":[", combinedStuff, @"szachyAscii"];
    for (int c=0; c<25; c++) {
        combinedStuff = [NSString stringWithFormat:@"%@\"%s\",", combinedStuff, tab_of_ascii[c].c_str() ];
    }
    combinedStuff = [NSString stringWithFormat:@"%@]", combinedStuff];
    
    combinedStuff = [NSString stringWithFormat:@"%@}", combinedStuff];
    combinedStuff = [combinedStuff stringByReplacingOccurrencesOfString:@",]"
                                                             withString:@"]"];
    return combinedStuff;
}

-(void) przygotujSzachownice: (Mat&)badanaFrameGray frameNum:(int)frameNum{
    //REMOVED FOR LITE
}



-(void)capture100ConvertPart: (Mat&)imagex{
    vector<KeyPoint> vkptest;
    //zbieramy 75frames
    bool czy_zebrano100 = [self processA:imagex];
    if ( czy_zebrano100 ){
        sendData = [[NSString alloc] init];
        sendData = @"";
        licznik_zapisanych_klatek = 0;
        //zebralismy to teraz je obrabiamy
        lastFrameTresholdInit = 75;
        for( int frameNum = 0; frameNum < frame_container.size(); frameNum++ ){
            Mat badanaFrame = frame_container[frameNum];
            //##1## => HUGES
            //##2## => LICZEBNOSC
            //##3## => SZACHOWNICE
        }
        
        sendData = [NSString stringWithFormat:@"%@]", sendData ];
        bool datasok = true;
        czy_zebrano100 = false;
        proceed_with_operation = false;
       
        if ( datasok ){
            double deltat = ( _t_first_touch - [[NSDate date] timeIntervalSince1970] );
            NSString* combinedStuff = [self przygotujDaneZTabelNaPotrzebyLinku];
            deltat = deltat - delaySekundy;
            
            NSDictionary* wynikDict0 = [self sendFingerDatasNew:@"1" deltaT:deltat data:combinedStuff hugesData:sendData algid:0 orb:nil verbose:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSMutableDictionary* topV = [wynikDict0 objectForKey:@"wynikSzachy"];
                UIWindow *win = [[UIApplication sharedApplication].windows objectAtIndex:0];
                
                self.wynikView = [[UIView alloc] initWithFrame:CGRectMake(0,0,win.frame.size.width-220, 100)];
                self.wynikView.layer.borderColor = [UIColor blackColor].CGColor;
                self.wynikView.layer.borderWidth = 1.0f;
                self.wynikView.layer.cornerRadius = 3.0f;
                self.wynikView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.45f];
                self.wynikView.center = CGPointMake( win.center.x, win.center.y );
                
                [self.wynikView removeFromSuperview];
                
                if ( [topV isEqual:[NSNull null] ] || [topV count] == 0 ){
                    NSLog(@"brak wyniku");
                }
                else{
                    NSArray* keys = [topV allKeys];
                    int countw = (int)[keys count];
                    int wyniknum = 0;
                    float oo = win.frame.size.width / (countw);
                    if( [keys count] == 1){
                        istniejeNowyWynik = YES;
                        [self.wynikView removeFromSuperview];
                        ostatniWynik = (long)[[keys objectAtIndex:0] intValue];
                    }
                    else{
                        for (NSString* film_id in keys) {
                            UIButton* bt = [[UIButton alloc] init];
                            [bt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"logo%@.png", film_id] ] forState:UIControlStateNormal ];
                            
                            int sizeH = self.wynikView.frame.size.height / 2;
                     
                            [bt setFrame:CGRectMake(  (oo * (wyniknum+1))-sizeH/2, self.wynikView.frame.size.height/2-sizeH/2, sizeH, sizeH)];
        //                    imageLogo.center = CGPointMake( win.center.x, win.center.y );
                            bt.layer.borderColor = [UIColor blackColor].CGColor;
                            bt.layer.borderWidth = 1.0f;
                            bt.layer.cornerRadius = 5;
                            bt.layer.masksToBounds = YES;
    //                        bt.transform = CGAffineTransformMakeRotation(-90*((float)M_PI / 180.0f));
                            bt.tag = [film_id intValue];
                            [bt addTarget:self
                                       action:@selector(selectedFilm:)
                             forControlEvents:UIControlEventTouchUpInside];
                            
                            [self.wynikView addSubview:bt];
                            
                            wyniknum++;
                            
                        }
                    
                        [win addSubview:self.wynikView];
                    }
                }
                
            });

        }
    }
    else{
//        NSLog(@"pozostało %d", time_to_end);
    }
}

-(void)selectedFilm:(UIButton*)button{
    NSLog(@"button CLickeD: %ld", (long)button.tag );
    istniejeNowyWynik = YES;
    [self.wynikView removeFromSuperview];
    ostatniWynik = (long)button.tag;
    
}

-(NSDictionary*)sendFingerDatasNew :(NSString*)user_id deltaT:(double)deltaT data:(NSString*)data hugesData:(NSString*)hugesData algid:(int)algid orb:(NSString*)orb verbose:(int)verbose
{
    double t0 = [[NSDate date] timeIntervalSince1970];
    //    orb = @"";
    //    AppDelegate* appDel = [[UIApplication sharedApplication] delegate];
    NSString* url = [NSString stringWithFormat:@"http://217.173.202.179:8080/vr/cmpLite.php"];
    NSString* poststring = [NSString stringWithFormat:@"verbose=%d&alg=%d&data=%@&hugesData=%@&deltaT=%.2f&orb=%@", verbose, algid, data, hugesData,deltaT, orb];
    NSLog(@"url: %@", url);
//    NSLog(@"poststring: %@", poststring);
    NSDictionary *resp_ = [self getResponseFromPostHTMLArray: url postString:poststring ];
    double t1 = [[NSDate date] timeIntervalSince1970];
    //    NSLog(@"resp: %@", resp_ );
    NSLog(@"--> sendFingerDatas time: %f", t1 - t0 );
    
    
    return resp_;
}

-(NSDictionary*)getResponseFromPostHTMLArray :(NSString*)url_string postString:(NSString*)postString {
    //    NSLog(@"getResponseFromPostHTMLArray: %@", url_string);
    NSURL *url2 = [NSURL URLWithString:url_string];
    //    NSLog(@"BO saveTag(): %@", content );
    NSMutableURLRequest *request2 = [NSMutableURLRequest requestWithURL:url2];
    [request2 setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse  *response2 = nil;
    NSError *error2 = nil;
    [request2 setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSData *responseData2;
    responseData2 = [NSURLConnection sendSynchronousRequest:request2 returningResponse:&response2 error:&error2];
    
    NSString *responseString =
    [[NSString alloc] initWithData:responseData2 encoding:NSUTF8StringEncoding];
    
    NSLog(@"responseString: %@", responseString );
    if ([response2 statusCode] == 200 && error2 == nil) {
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:responseData2 //1
                              options:kNilOptions
                              error:&error2];
        return json;
    }
    else{
        return nil;
    }
}


#endif





@end
