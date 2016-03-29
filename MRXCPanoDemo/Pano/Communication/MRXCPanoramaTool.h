//
//  MRXCPanoramaData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MRXCPanoramaJsonData.h"

@interface MRXCPanoramaTool : NSObject

+ (NSString *)achieveJSONString:(NSString *)response;
+ (NSString *)achieveRouteString:(NSString *)response;
+ (NSString *)achieveUnityPathString:(NSString *)response;
+ (CGFloat)compatibleWidth:(CGFloat)originalWidth;
+ (CGFloat)multipleResolution;
+ (NSString *)supplementSpace:(NSString *)string;
+ (UIColor *)getColorFromHex:(NSString *)hexColor;

+(UIImage *)imageInRect:(UIImage *)image x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
@end
