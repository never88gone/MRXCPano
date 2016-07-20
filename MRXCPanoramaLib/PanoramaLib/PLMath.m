//
//  PLMath.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLMath.h"

@implementation PLMath

#pragma mark -
#pragma mark distance methods

+ (float)distanceBetweenPoints:(CGPoint)point1 :(CGPoint)point2;
{
	return sqrt(((point2.x - point1.x) * (point2.x - point1.x)) + ((point2.y - point1.y) * (point2.y - point1.y)));
}

#pragma mark -
#pragma mark range methods

+ (float)valueInRange:(float)value range:(PLRange)range
{
	return MAX(range.min, MIN(value, range.max));
}

#pragma mark -
#pragma mark normalize methods

+ (float)normalizeAngle:(float)angle range:(PLRange)range;
{	
	float result = angle;
    if( range.min < 0.0f )
	{
        while (result <= -180.0f) result += 360.0f;
        while (result > 180.0f) result -= 360.0f;
    } 
	else 
	{
        while (result < 0.0f) result += 360.0f;
        while (result >= 360.0f) result -= 360.0f;
    }
	return [PLMath valueInRange:result range:range];
}

+ (float)normalizeFov:(float)fov range:(PLRange)range
{
	return [PLMath valueInRange:fov range:range];
}

+ (BOOL)isPowerOfTwo:(int)value
{
	while (!(value & 1))
		value = value >> 1;
	return (value == 1);
}

@end
