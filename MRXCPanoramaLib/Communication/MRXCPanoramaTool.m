//
//  MRXCPanoramaData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCPanoramaTool.h"
#import "JSONKit.h"

@implementation MRXCPanoramaTool

+ (NSString *)achieveJSONString:(NSString *)response{
    char *xmlString = (char *)[response UTF8String];
    //prefix[]="<?xml version=\"1.0\" encoding=\"utf-8\"?><string xmlns=\"http://tempuri.org/\">";
    //char *pprefix = strchr(xmlString, '[');
    char *pprefix = NULL;
    for(int i = 0; i < strlen(xmlString); i ++){
        if(*(xmlString+i) == '[' || *(xmlString+i) == '{'){
            pprefix = xmlString + i;
            break;
        }
    }
    char suffix[]="</string>";
    xmlString[strlen(xmlString)-strlen(suffix)] = 0;
    NSString *jsonString = [[NSString alloc]initWithBytes:pprefix length:(strlen(pprefix)) encoding:NSUTF8StringEncoding];
    //NSString *JsonString = [NSString stringWithFormat:@"%s", pprefix];
    return jsonString;
}
+ (NSString *)achieveRouteString:(NSString *)response{
    //NSLog(@"achieveRouteString[%u] %@", response.length,  response);
    NSRange prefixrange = [response rangeOfString:@"<webport>"];
    NSRange suffixrange = [response rangeOfString:@"</webport>"];
    return [response substringWithRange:NSMakeRange(prefixrange.location+prefixrange.length, suffixrange.location-prefixrange.location-prefixrange.length)];
}
+ (NSString *)achieveUnityPathString:(NSString *)response{
    //NSLog(@"achieveUnityPathString[%u] %@", response.length,  response);
    NSRange prefixrange = [response rangeOfString:@"<datas>"];
    NSRange suffixrange = [response rangeOfString:@"</datas>"];
    return [response substringWithRange:NSMakeRange(prefixrange.location+prefixrange.length, suffixrange.location-prefixrange.location-prefixrange.length)];
}
+ (CGFloat)compatibleWidth:(CGFloat)originalWidth{
    CGFloat width;
    NSString *model = [[UIDevice currentDevice] model];
    if([model isEqualToString:@"iPad"] || [[model substringToIndex:4] isEqualToString:@"iPad"]){
        width = originalWidth*768.0/320.0;
    }
    else{
        width = originalWidth;
    }
    return originalWidth;
}
+ (CGFloat)multipleResolution{
    CGFloat multiple;
    NSString *model = [[UIDevice currentDevice] model];
    if([model isEqualToString:@"iPad"] || [[model substringToIndex:4] isEqualToString:@"iPad"]){
        multiple = 768.00/320.00;
    }
    else{
        multiple = 1.00;
    }
    return 1.0;
}
+ (NSString *)supplementSpace:(NSString *)string{
    NSInteger place = 0;
    NSString *temp = nil;
    NSString *space = nil;
    for(; place < string.length; place ++){
        if([string characterAtIndex:place] != 0x20){
            break;
        }
    }
    if(place == 0){
        space = [[NSString alloc]initWithFormat:@"        %@", string];
    }
    else{
        temp = [string substringFromIndex:place];
        space = [[NSString alloc]initWithFormat:@"        %@", temp];
    }
    return space;
}
+ (UIColor *)getColorFromHex:(NSString *)hexColor{
    unsigned int red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 0;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location = 2;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location = 4;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0];
}

+(UIImage *)imageInRect:(UIImage *)image x:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height{
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *rectImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return rectImage;
}

+(id)formatToDicWithJsonStr:(NSString*)jsonStr
{
    id jsonDic = [jsonStr objectFromJSONString];
    return jsonDic;

}

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
