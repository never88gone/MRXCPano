//
//  PLCamera.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLCamera.h"

@interface  PLCamera()

//- (void)initializeValues;

@end


@implementation PLCamera

@synthesize isFovEnabled;
@synthesize fov, fovSensitivity;
@synthesize fovFactor;
@synthesize fovRange, fovFactorRange;

#pragma mark -
#pragma mark init methods

+ (id)camera
{
	return [[PLCamera alloc] init];
}

- (void)initializeValues
{
	fovRange = PLRangeMake(kDefaultFovMinValue, kDefaultFovMaxValue);
	isFovEnabled = YES;
	fovSensitivity = kDefaultFovSensitivity;
	fovFactorRange = PLRangeMake(kDefaultFovFactorMinValue, kDefaultFovFactorMaxValue);
	[super initializeValues];
}

- (void)reset
{
	self.fov = fovRange.min + ([PLMath distanceBetweenPoints:CGPointMake(fovRange.min, 0.0f) :CGPointMake(fovRange.max, 0.0f)] / 2.0f); 
	[super reset];
}


#pragma mark -
#pragma mark fov methods

- (void)setFov:(float)value
{
	if(isFovEnabled)
	{
		fov = [PLMath normalizeFov:value range:fovRange];
		if(fov <= fovRange.min)
			fovFactor = fovFactorRange.min;
		else if(fov >= fovRange.max)
			fovFactor = fovFactorRange.max;
		else 
		{
			if(fov < 0.0f)
				fovFactor = kFovFactorOffsetValue - ((kFovFactorOffsetValue - fovFactorRange.min) / (fovRange.min/fov));
			else
				fovFactor = ABS((fov * (fovFactorRange.max - kFovFactorOffsetValue)) / fovRange.max) + kFovFactorOffsetValue;
		}
	}
}

- (void)addFovWithDistance:(float)distance;
{
	self.fov += (distance / fovSensitivity);
}

- (void)addFovWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sign:(int)sign
{
	[self addFovWithDistance: [PLMath distanceBetweenPoints:startPoint :endPoint] * (sign < 0 ? -1 : 1)];
}

#pragma mark -
#pragma mark utility methods

- (void)cloneCameraProperties:(PLCamera *)value
{
	isFovEnabled = value.isFovEnabled;
	fovRange = value.fovRange;
	fovFactorRange = value.fovFactorRange;
	self.fov = value.fov;
	[super clonePropertiesOf:(PLObject *)value];
}

@end
