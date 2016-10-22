//
//  UIImage+Sacle.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "UIImage+Sacle.h"

@implementation UIImage(Sacle)
-(UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height
{
        CGFloat
        destW = width;
        
        CGFloat
        destH = height;
        
        CGFloat
        sourceW = width;
        
        CGFloat
        sourceH = height;
        
        
        
        CGImageRef
        imageRef = self.CGImage;
        
        CGContextRef
        bitmap = CGBitmapContextCreate(NULL,
                                       
                                       destW,
                                       
                                       destH,
                                       
                                       CGImageGetBitsPerComponent(imageRef),
                                       
                                       4*destW,
                                       
                                       CGImageGetColorSpace(imageRef),
                                       
                                       (kCGBitmapByteOrder32Little
                                        | kCGImageAlphaPremultipliedFirst));
        
        
        
        CGContextDrawImage(bitmap,
                           CGRectMake(0, 0, sourceW, sourceH), imageRef);
        
        
        
        CGImageRef
        ref = CGBitmapContextCreateImage(bitmap);
        
        UIImage
        *result = [UIImage imageWithCGImage:ref];
        
        CGContextRelease(bitmap);
        
        CGImageRelease(ref);
        
        
        
        return result;
}
-(CGFloat)DegreesToRadians:(CGFloat)degress
{
    return degress*M_PI/180.0;
}

- (UIImage *)imageRotateRotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
    
}

@end
