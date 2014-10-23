//
//  ARFHuges.h
//  xxx
//
//  Created by Marcin Niedźwiecki on 01.08.2014.
//  Copyright (c) 2014 Marcin Niedźwiecki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/cap_ios.h>
#import <opencv2/highgui/ios.h>
#import <opencv2/opencv.hpp>


using namespace cv;

class TrojkatClass {
    int width, height;
    
    
public:
    Point2f corner1, corner2, corner3, barycentrum;
    double bok1, bok2, bok3;
    double angle1, angle2, angle3;
    double pole;
    cv::Rect bRect;
    
    
    void set_pole(){
        double PI = 3.14159265;
        float obw = bok1 + bok2 + bok3;
        float p = obw / 2;
        float tg0 = tan ( (angle1 * PI / 180.0) /2 );
        float tg1 = tan ( (angle2 * PI / 180.0) /2 );
        float tg2 = tan ( (angle3 * PI / 180.0) /2 );
        pole = p*p * tg0 * tg1 * tg2;
    }
    
    void set_corners_angles() {
        float dx10 = corner2.x-corner1.x;
        float dx20 = corner3.x-corner1.x;
        float dy10 = corner2.y-corner1.y;
        float dy20 = corner3.y-corner1.y;
        float m01 = sqrt( dx10*dx10 + dy10*dy10 );
        float m02 = sqrt( dx20*dx20 + dy20*dy20 );
        float theta1 = acos( (dx10*dx20 + dy10*dy20) / (m01 * m02) );
        angle1 =  theta1 * 180 / 3.14159258;
        
        
        float dx01 = corner1.x-corner2.x;
        float dx21 = corner3.x-corner2.x;
        float dy01 = corner1.y-corner2.y;
        float dy21 = corner3.y-corner2.y;
        float m10 = sqrt( dx10*dx10 + dy10*dy10 );
        float m21 = sqrt( dx21*dx21 + dy21*dy21 );
        float theta2 = acos( (dx01*dx21 + dy01*dy21) / (m10 * m21) );
        angle2 =  theta2 * 180 / 3.14159258;
        
        float dx02 = corner1.x-corner3.x;
        float dx12 = corner2.x-corner3.x;
        float dy02 = corner1.y-corner3.y;
        float dy12 = corner2.y-corner3.y;
        float m20 = sqrt( dx20*dx20 + dy20*dy20 );
        float m12 = sqrt( dx12*dx12 + dy12*dy12 );
        float theta3 = acos( (dx02*dx12 + dy02*dy12) / (m20 * m12) );
        angle3 =  theta3 * 180 / 3.14159258;
        
        
    }
    
    void set_all(Point2f c1,Point2f c2,Point2f c3){
        //    std::cout << "dsfdsfdsfds";
        //    NSLog( @"TrojkatClass: %f %f", c1.x, c1.y );
        corner1 = c1;
        corner2 = c2;
        corner3 = c3;
        
        bok1 = cv::norm(corner1-corner2);
        bok2 = cv::norm(corner1-corner3);
        bok3 = cv::norm(corner2-corner3);
        
        vector<Point2f> x ;
        x.clear();
        x.push_back(c1);
        x.push_back(c2);
        x.push_back(c3);
        bRect = boundingRect( x );
        
        barycentrum = Point2f( (c1.x + c2.x + c3.x)/3, (c1.y + c2.y + c3.y)/3 );
        
        
        this->set_corners_angles();
        this->set_pole();
        
    }
    
    
    TrojkatClass (Point2f c1,Point2f c2,Point2f c3) {
        
        corner1 = c1;
        corner2 = c2;
        corner3 = c3;
        
        bok1 = cv::norm(corner1-corner2);
        bok2 = cv::norm(corner1-corner3);
        bok3 = cv::norm(corner2-corner3);
        
        vector<Point2f> x ;
        x.clear();
        x.push_back(c1);
        x.push_back(c2);
        x.push_back(c3);
        bRect = boundingRect( x );
        
        this->set_corners_angles();
        this->set_pole();
    }
    
};


@interface ARFHuges : NSObject
-(bool) sprawdzCzySaConajmniejTrzy:(Point2f)hugeNr1 :(Point2f)hugeNr2 :(Point2f)hugeNr3 :(Point2f)hugeNr4 :(Point2f)hugeNr5 :(Point2f)hugeNr6;
-(void) echoHuges:(Point2f)hugeNr1 :(Point2f)hugeNr2 :(Point2f)hugeNr3 :(Point2f)hugeNr4 :(Point2f)hugeNr5 :(Point2f)hugeNr6;
-(cv::vector<cv::Point2f>)getHuges:(cv::vector<cv::KeyPoint>)kps odl:(int)odl;-(BOOL)hugesMake: (vector<KeyPoint>)kpsnomargin odl:(int)odl hugePoints:(cv::vector<cv::Point2f>&)hugePoints
hugeNr1: (Point2f&)hugeNr1 hugeNr2: (Point2f&)hugeNr2 hugeNr3: (Point2f&)hugeNr3
hugeNr4: (Point2f&)hugeNr4 hugeNr5: (Point2f&)hugeNr5 hugeNr6: (Point2f&)hugeNr6;

+ (vector<KeyPoint>)odfiltrujKPDoDlaszychTestow: (vector<KeyPoint>)kps hugePoint:(Point2f)hugePoint odl:(int)odl;


@end
