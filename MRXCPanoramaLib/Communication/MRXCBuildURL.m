//
//  MRXCBuildURL.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCBuildURL.h"


@implementation MRXCBuildURL

+ (NSString *)achieveURLString:(NSString *)string{
    NSString *urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)string, NULL,(CFStringRef)@":/?=,!$&'()*+;[]@#",kCFStringEncodingUTF8));
    return urlString;
}
+ (NSString *)achieveURLCodeString:(NSString *)string{
    if(string == nil){
        return @"";
    }
    NSString *urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)string, NULL,(CFStringRef)@":/?=,!$&'()*+;[]@#",kCFStringEncodingUTF8));
    return urlString ;
}


@end
