//
//  ShareColor.m
//  EPOS
//
//  Created by never88gone on 16/5/19.
//  Copyright © 2016年 mrxc. All rights reserved.
//

#import "ShareColor.h"

@implementation ShareColor
+ (UIColor *)colorWithRGB:(NSUInteger)aRGB
{
    return [UIColor colorWithRed:((float)((aRGB & 0xFF0000) >> 16))/255.0 green:((float)((aRGB & 0xFF00) >> 8))/255.0 blue:((float)(aRGB & 0xFF))/255.0 alpha:1.0];
}
+ (UIColor *)mainColor
{
    UIColor* mainColor=[ShareColor colorWithRGB:0x3089c8];
    return mainColor;
}
+ (UIColor *)eposLightColor
{
   return [ShareColor colorWithRGB:0xbbbbbb];
}
@end
