//
//  PLImage.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <UIKit/UIImage.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/NSData.h>

@interface PLImage : NSObject 
{
	CGImageRef cgImage;
	size_t width, height;
}

@property(nonatomic, readonly, getter=getWidth) int width;
@property(nonatomic, readonly, getter=getHeight) int height;

@property(nonatomic, readonly, getter=getCGImage) CGImageRef CGImage;

@property(nonatomic, readonly, getter=getCount) int count;
@property(nonatomic, readonly, getter=getBits) unsigned char * bits;

- (id)initWithCGImage:(CGImageRef)image;
- (id)initWithSize:(CGSize)size;
- (id)initWithDimensions:(int)width :(int)height;
- (id)initWithPath:(NSString *)path;

+ (id)imageWithSizeZero;
+ (id)imageWithCGImage:(CGImageRef)image;
+ (id)imageWithSize:(CGSize)size;
+ (id)imageWithDimensions:(int) width :(int)height;
+ (id)imageWithPath:(NSString *)path;

- (int)getWidth;
- (int)getHeight;
- (CGSize)getSize;
- (CGRect)getRect;

- (CGImageRef)getCGImage;

- (int)getCount;
- (unsigned char *)getBits;

- (BOOL)isValid;
- (BOOL)equals:(PLImage *)image;
- (PLImage *)assign:(PLImage *)image;

- (PLImage *)clone;
- (CGImageRef)cloneCGImage;

- (PLImage *)crop:(CGRect)rect;

- (PLImage *)scale:(CGSize)size;

- (PLImage *)rotate:(int)angle;

- (PLImage *)mirrorHorizontally;
- (PLImage *)mirrorVertically;
- (PLImage *)mirror:(BOOL)horizontally :(BOOL)vertically;

- (BOOL)save:(NSString *)path;
- (BOOL)save:(NSString *)path quality:(int)quality;

@end
