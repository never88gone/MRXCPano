//
//  MRXCAdjacentPanoData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRXCAdjacentPanoData : NSObject{
    NSString *_angle;
    NSString *_dstImageID;
    NSString *_dstImageName;
    NSString *_dstName;
    NSString *_linkID;
    NSString *_projectID;
    NSString *_srcImageID;
    NSString *_srcImageName;
    NSString *_x;
    NSString *_y;
    NSString *_z;
}
@property(strong, nonatomic)NSString *angle;
@property(strong, nonatomic)NSString *dstImageID;
@property(strong, nonatomic)NSString *dstImageName;
@property(strong, nonatomic)NSString *dstName;
@property(strong, nonatomic)NSString *linkID;
@property(strong, nonatomic)NSString *projectID;
@property(strong, nonatomic)NSString *srcImageID;
@property(strong, nonatomic)NSString *srcImageName;
@property(strong, nonatomic)NSString *x;
@property(strong, nonatomic)NSString *y;
@property(strong, nonatomic)NSString *z;

+(NSArray *)parserAdjacentPanoData:(NSDictionary *)dictionary;
+(MRXCAdjacentPanoData *)createAdjacentPanoData:(NSDictionary *)dictionary;

@end
