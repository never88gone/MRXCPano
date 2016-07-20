//
//  PLMath.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLStructs.h"

@interface PLMath : NSObject 

+ (float)distanceBetweenPoints:(CGPoint)point1 :(CGPoint)point2;

+ (float)valueInRange:(float)value range:(PLRange)range;

+ (float)normalizeAngle:(float)angle range:(PLRange)range;
+ (float)normalizeFov:(float)fov range:(PLRange)range;

+ (BOOL)isPowerOfTwo:(int)value;

@end
