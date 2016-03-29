//
//  PLUtils.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLUtils.h"

@implementation PLUtils

#pragma mark -
#pragma mark swap methods

+ (void)swapFloatValues:(float *)firstValue :(float *)secondValue
{
	float swapValue = *firstValue;
	*firstValue = *secondValue;
	*secondValue = swapValue;
}

+ (void)swapIntValues:(int *)firstValue :(int *)secondValue
{
	*firstValue = *firstValue ^ *secondValue;
	*secondValue = *secondValue ^ *firstValue;
	*firstValue = *firstValue ^ *secondValue;
}

@end
