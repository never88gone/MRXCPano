//
//  PLObject.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLObject.h"

@interface PLObject()



@end


@implementation PLObject

@synthesize isXAxisEnabled, isYAxisEnabled, isZAxisEnabled;
@synthesize position;
@synthesize xRange, yRange, zRange;

@synthesize isPitchEnabled, isYawEnabled, isRollEnabled, isReverseRotation;
@synthesize rotation;
@synthesize pitchRange, yawRange, rollRange;
@synthesize rotateSensitivity;

@synthesize orientation;

#pragma mark -
#pragma mark init methods

- (id)init{
	if(self = [super init])
		[self initializeValues];
	return self;
}
- (void)initializeValues
{
	xRange = yRange = zRange = PLRangeMake(kFloatMinValue, kFloatMaxValue);
	pitchRange = PLRangeMake(kDefaultRotateMinRange+90.0f, kDefaultRotateMaxRange-90.0f);
	yawRange = PLRangeMake(kDefaultRotateMinRange, kDefaultRotateMaxRange);
    rollRange = PLRangeMake(kDefaultRotateMinRange, kDefaultRotateMaxRange);
	isXAxisEnabled = isYAxisEnabled = isZAxisEnabled = YES;
	isPitchEnabled = isYawEnabled = isRollEnabled = YES;
	
	rotateSensitivity = kDefaultRotateSensitivity;	
	isReverseRotation = NO;
	
	oldOrientation = orientation = UIDeviceOrientationUnknown;
	
	[self reset];
}

- (void)reset
{
	position = PLPositionMake(0.0f, 0.0f, 0.0f);
	rotation = PLRotationMake(0.0f, 0.0f, 0.0f);
}

#pragma mark -
#pragma mark translate methods

- (void)translateWithX:(float)xValue y:(float)yValue
{
	position.x = xValue;
	position.y = yValue;
}

- (void)translateWithX:(float)xValue y:(float)yValue z:(float)zValue
{
	position = PLPositionMake(xValue, yValue, zValue);
}

#pragma mark -
#pragma mark rotate methods

- (void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue
{
	self.pitch = pitchValue;
	self.yaw = yawValue;
}

- (void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue roll:(float)rollValue
{
	self.rotation = PLRotationMake(pitchValue, yawValue, rollValue);
}

- (void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
	[self rotateWithStartPoint:startPoint endPoint:endPoint sensitivity:rotateSensitivity];
}

- (void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sensitivity:(float)sensitivity
{
//    旋转方向反转
//	self.pitch += (endPoint.y - startPoint.y) / sensitivity;
//	self.yaw += (startPoint.x - endPoint.x) / sensitivity;
    self.pitch += (startPoint.y - endPoint.y) / sensitivity;
	self.yaw += (endPoint.x - startPoint.x) / sensitivity;
}

#pragma mark -
#pragma mark position property methods

- (void)setPosition:(PLPosition)value
{
	[self setX:value.x];
	[self setY:value.y];
	[self setZ:value.z];
}

- (float)getX
{
	return position.x;
}

- (void)setX:(float)value
{
	if(isXAxisEnabled)
		position.x = [PLMath valueInRange:value range:xRange];
}

- (float)getY
{
	return position.y;
}

- (void)setY:(float)value
{
	if(isYAxisEnabled)
		position.y = [PLMath valueInRange:value range:yRange];
}

- (float)getZ
{
	return position.z;
}

- (void)setZ:(float)value
{
	if(isZAxisEnabled)
		position.z = [PLMath valueInRange:value range:zRange];
}

#pragma mark -
#pragma mark rotation property methods

- (void)setRotation:(PLRotation)value
{
	[self setPitch:value.pitch];
	[self setYaw:value.yaw];
	[self setRoll:value.roll];
}

- (float)getPitch
{
	return rotation.pitch;
}

- (void)setPitch:(float)value
{
	if(isPitchEnabled)
		rotation.pitch = [PLMath normalizeAngle:value range:pitchRange];
}
		
- (float)getYaw
{
	return rotation.yaw;
}

- (void)setYaw:(float)value
{
	if(isYawEnabled)
		rotation.yaw = [PLMath normalizeAngle:value range:PLRangeMake(-yawRange.max, -yawRange.min)];
}

- (float)getRoll
{
	return rotation.roll;
}

- (void)setRoll:(float)value
{
	if(isRollEnabled)
		rotation.roll = [PLMath normalizeAngle:value range:rollRange];
}

#pragma mark -
#pragma mark orientation methods

- (void)setOrientation:(UIDeviceOrientation)value
{
	if(value != UIDeviceOrientationFaceUp && value != UIDeviceOrientationFaceDown)
	{
		oldOrientation = orientation;
		orientation = value;
	}
}

#pragma mark -
#pragma mark utility methods

- (void)clonePropertiesOf:(PLObject *)value
{	
	self.isXAxisEnabled = value.isXAxisEnabled;
	self.isYAxisEnabled = value.isYAxisEnabled;
	self.isZAxisEnabled = value.isZAxisEnabled;
	
	self.isPitchEnabled = value.isPitchEnabled;
	self.isYawEnabled = value.isYawEnabled;
	self.isRollEnabled = value.isRollEnabled;
	
	self.isReverseRotation = value.isReverseRotation;
	
	self.rotateSensitivity = value.rotateSensitivity;
	
	self.xRange = value.xRange;
	self.yRange = value.yRange;
	self.zRange = value.zRange;
	
	self.pitchRange = value.pitchRange;
	self.yawRange = value.yawRange;
	self.rollRange = value.rollRange;
	
	self.x = value.x;
	self.y = value.y;
	self.z = value.z;
	
	self.pitch = value.pitch;
	self.yaw = value.yaw;
	self.roll = value.roll;
	
	self.orientation = value.orientation;
}

@end

