//
//  MRXCPanoramaIDData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRXCPanoramaIDData : NSObject{
    NSString *_b;
    NSString *_cameraNo;
    NSString *_gatherTime;
    NSString *_imageID;
    NSString *_l;
    NSString *_pitch;
    NSString *_roadName;
    NSString *_roll;
    NSString *_routeID;
    NSString *_segmentID;
    NSString *_segmentIndex;
    NSString *_x;
    NSString *_y;
    NSString *_yaw;
    NSString *_z;
}
@property(strong, nonatomic)NSString *b;
@property(strong, nonatomic)NSString *cameraNo;
@property(strong, nonatomic)NSString *gatherTime;
@property(strong, nonatomic)NSString *imageID;
@property(strong, nonatomic)NSString *l;
@property(strong, nonatomic)NSString *pitch;
@property(strong, nonatomic)NSString *roadName;
@property(strong, nonatomic)NSString *roll;
@property(strong, nonatomic)NSString *routeID;
@property(strong, nonatomic)NSString *segmentID;
@property(strong, nonatomic)NSString *segmentIndex;
@property(strong, nonatomic)NSString *x;
@property(strong, nonatomic)NSString *y;
@property(strong, nonatomic)NSString *yaw;
@property(strong, nonatomic)NSString *z;

+(MRXCPanoramaIDData *)createPanoramaIDData:(NSDictionary *)dictionary;
@end
