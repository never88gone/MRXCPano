//
//  MRXCSiteJsonData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRXCSiteJsonData : NSObject{
    NSString *_imgurl;
    NSString *_guid;
    NSString *_name;
    NSString *_age;
    NSString *_type;
    NSString *_location;
    NSString *_x;
    NSString *_y;
}
@property(strong, nonatomic)NSString *imgurl;
@property(strong, nonatomic)NSString *guid;
@property(strong, nonatomic)NSString *name;
@property(strong, nonatomic)NSString *age;
@property(strong, nonatomic)NSString *type;
@property(strong, nonatomic)NSString *location;
@property(strong, nonatomic)NSString *x;
@property(strong, nonatomic)NSString *y;

+(NSArray *)parserSiteJsonData:(NSObject *)object;
+(MRXCSiteJsonData *)createSiteJsonData:(NSDictionary *)dictionary;
@end
