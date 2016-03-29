//
//  MRXCBuildURL.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <UIKit/UIKit.h>
@interface MRXCBuildURL : NSObject

+ (NSString *)achieveURLString:(NSString *)string;
+ (NSString *)achieveURLCodeString:(NSString *)string;
@end
