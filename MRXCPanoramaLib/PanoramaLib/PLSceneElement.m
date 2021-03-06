//
//  PLSceneElement.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSceneElement.h"

@interface PLSceneElement()

- (void)evaluateIfElementIsValid;

- (void)translate;
- (void)rotate;
- (void)internalRotate:(PLRotation)rotationValue orientation:(PLOrientation)orientationValue rotationSign:(int)rotationSign;

- (void)beginRender;
- (void)endRender;
- (void)internalRender;

- (void)changeOrientation:(UIDeviceOrientation)orientation oldOrientation:(UIDeviceOrientation)oldOrientation;

- (void)swapPitchValues;
- (void)swapPitchValuesWithSign:(BOOL)sign;
- (void)swapYawValues;
- (void)swapYawValuesWithSign:(BOOL)sign;
- (void)swapPitchRangeByYawRange:(int)swapPitchValue swapYawValue:(int)swapYawValue;
- (void)swapPitchRangeByYawRange:(BOOL)isSwapPitchValues isSwapYawValues:(BOOL)isSwapYawValues isSwapPitchSign:(BOOL)isSwapPitchSign isSwapYawSign:(BOOL)isSwapYawSign;

@end


@implementation PLSceneElement

@synthesize isVisible;
@synthesize isValid;
@synthesize textures;

#pragma mark -
#pragma mark init methods

- (id)initWithTexture:(PLTexture *)texture
{
	if(self = [super init])
		[self addTexture:texture];
	return self;
}

- (void)initializeValues
{
	[super initializeValues];
	isVisible = YES;
	isValid = NO;
	self.textures = [[NSMutableArray alloc] init];
}

#pragma mark -
#pragma mark texture methods

- (NSMutableArray *)getTextures
{
	return textures;
}

- (void)addTexture:(PLTexture *)texture
{
	//if(texture.isValid)
	//{
		[textures addObject:texture];
//		[self evaluateIfElementIsValid];
	//}
}

- (void)removeTexture:(PLTexture *)texture
{
	//if(texture.isValid)
	//{
		[textures removeObject:texture];
		//[self evaluateIfElementIsValid];
	//}
}

- (void)removeTextureAtIndex:(NSUInteger)index
{
	[textures removeObjectAtIndex:index];
	[self evaluateIfElementIsValid];
}

- (void)removeAllTextures
{
	[textures removeAllObjects];
	[self evaluateIfElementIsValid];
}

#pragma mark -
#pragma mark utility methods

- (void)evaluateIfElementIsValid
{
	isValid = [textures count] > 0; 
}

#pragma mark -
#pragma mark action methods

- (void)translate
{
	glTranslatef(isXAxisEnabled ? position.x : 0.0f, isYAxisEnabled ? position.y : 0.0f, isZAxisEnabled ? position.z : 0.0f);
}

- (void)rotate
{
	PLOrientation orientationValue;
	int rotationSign = 0;
	switch (orientation) 
	{
		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationPortrait:
			rotationSign = 1;
		case UIDeviceOrientationPortraitUpsideDown:
			if(!rotationSign)
				rotationSign = -1;
			orientationValue = PLOrientationPortrait;
			break;
		case UIDeviceOrientationLandscapeLeft:
			rotationSign = -1;
		case UIDeviceOrientationLandscapeRight:
			if(!rotationSign)
				rotationSign = 1;
			orientationValue = PLOrientationLandscape;
			break;
		default:
			rotationSign = 1;
			orientationValue = PLOrientationUnknown;
			break;
	}
	[self internalRotate:rotation orientation:orientationValue rotationSign:rotationSign];
}

- (void) internalRotate:(PLRotation)rotationValue orientation:(PLOrientation)orientationValue rotationSign:(int)rotationSign
{	
	if(orientationValue == PLOrientationLandscape)
	{
		if(isPitchEnabled)
			glRotatef(rotationSign * rotationValue.yaw * (isReverseRotation ? -1.0f : 1.0f), 1.0f, 0.0f, 0.0f);
		if(isYawEnabled)
			glRotatef(rotationSign * rotationValue.pitch * (isReverseRotation ? 1.0f : -1.0f), 0.0f, 0.0f, 1.0f);
	}
	else
	{
		if(isPitchEnabled)
			glRotatef(rotationSign * rotationValue.pitch * (isReverseRotation ? 1.0f : -1.0f), 1.0f, 0.0f, 0.0f);
		if(isYawEnabled)
			glRotatef(rotationSign * rotationValue.yaw * (isReverseRotation ? 1.0f : -1.0f), 0.0f, 0.0f, 1.0f);
	}
	if(isRollEnabled)
		glRotatef(rotationValue.roll * (isReverseRotation ? 1.0f : -1.0f), 0.0f, 1.0f, 0.0f);
}

#pragma mark -
#pragma mark render methods

- (void)beginRender
{
	glPushMatrix();
	
	[self translate];
	[self rotate];
}

- (void)endRender
{
	glPopMatrix();
}

- (BOOL)render
{
    [self evaluateIfElementIsValid];
	if(isValid)
	{
		[self beginRender];
		[self internalRender];
		[self endRender];
		return YES;
	}
	return NO;
//    [self beginRender];
//    [self internalRender];
//    [self endRender];
//    return YES;
}

- (void)internalRender
{
}

#pragma mark -
#pragma mark swap methods

- (void)swapPitchValues
{
	[self swapPitchValuesWithSign:NO];
}

- (void)swapPitchValuesWithSign:(BOOL)sign
{
	if(sign)
	{
		pitchRange.min = -pitchRange.min;
		pitchRange.max = -pitchRange.max;
	}
	[PLUtils swapFloatValues:(float *)&pitchRange.min :(float *)&pitchRange.max];
}

- (void)swapYawValues
{
	[self swapYawValuesWithSign:NO];
}

- (void)swapYawValuesWithSign:(BOOL)sign
{
	if(sign)
	{
		yawRange.min = -yawRange.min;
		yawRange.max = -yawRange.max;
	}
	[PLUtils swapFloatValues:(float *)&yawRange.min :(float *)&yawRange.max];
}

- (void)swapPitchRangeByYawRange:(BOOL)isSwapPitchValues isSwapYawValues:(BOOL)isSwapYawValues isSwapPitchSign:(BOOL)isSwapPitchSign isSwapYawSign:(BOOL)isSwapYawSign
{
	if(isSwapPitchValues)
		[self swapPitchValues];
	if(isSwapYawValues)
		[self swapYawValues];
	
	if(isSwapPitchSign)
		pitchRange = PLRangeMake(-pitchRange.min, -pitchRange.max);
	if(isSwapYawSign)
		yawRange = PLRangeMake(-yawRange.min, -yawRange.max);
	
	PLRange swapRange = pitchRange;
	pitchRange = yawRange;
	yawRange = swapRange;
}

- (void)swapPitchRangeByYawRange:(int)swapPitchValue swapYawValue:(int)swapYawValue
{
	[self swapPitchRangeByYawRange:swapPitchValue isSwapYawValues:swapYawValue isSwapPitchSign:swapPitchValue < 0 isSwapYawSign:swapYawValue < 0];
}

#pragma mark -
#pragma mark orientation methods

- (void)setOrientation:(UIDeviceOrientation)value
{
	if(value != UIDeviceOrientationFaceUp && value != UIDeviceOrientationFaceDown)
	{
		if(orientation != value)
		{
			oldOrientation = orientation;
			orientation = value;
			[self changeOrientation:orientation oldOrientation:oldOrientation];
		}
	}
}

- (void)changeOrientation:(UIDeviceOrientation)orientationValue oldOrientation:(UIDeviceOrientation)oldOrientationValue
{	
	float pitch = rotation.pitch, yaw = rotation.yaw;
	float swap = rotation.pitch;
	switch (orientationValue) 
	{
		//The orientation of the device cannot be determined.
		case UIDeviceOrientationUnknown:
		//The device is in portrait mode, with the device held upright and the home button at the bottom. (normal)
		case UIDeviceOrientationPortrait:
			switch(oldOrientationValue)
			{
				case UIDeviceOrientationPortraitUpsideDown:
					pitch = -pitch;
					yaw = -yaw;
					[self swapPitchValuesWithSign:YES];
					[self swapYawValuesWithSign:YES];
					break;
				case UIDeviceOrientationLandscapeLeft:
					pitch = yaw;
					yaw = -swap;
					[self swapPitchRangeByYawRange:0 swapYawValue:-1];
					break;
				case UIDeviceOrientationLandscapeRight:
					pitch = -yaw;	
					yaw = swap;
					[self swapPitchRangeByYawRange:-1 swapYawValue:0];
					break;
			}
			break;
		//The device is in portrait mode but upside down, with the device held upright and the home button at the top. (normal mirror)
		case UIDeviceOrientationPortraitUpsideDown:
			switch(oldOrientationValue)
			{
				case UIDeviceOrientationPortrait:
					pitch = -pitch;
					yaw = -yaw;
					[self swapPitchValuesWithSign:YES];
					[self swapYawValuesWithSign:YES];
					break;
				case UIDeviceOrientationLandscapeLeft:
					pitch = -yaw;
					yaw = swap;
					[self swapPitchRangeByYawRange:-1 swapYawValue:0];
					break;
				case UIDeviceOrientationLandscapeRight:
					pitch = yaw;
					yaw = -swap;
					[self swapPitchRangeByYawRange:0 swapYawValue:-1];
					break;
			}
			break;
		//The device is in landscape mode, with the device held upright and the home button on the right side. (button right side)
		case UIDeviceOrientationLandscapeLeft:
			switch(oldOrientationValue)
			{
				case UIDeviceOrientationUnknown:
				case UIDeviceOrientationPortrait:
					pitch = -yaw;
					yaw = swap;
					[self swapPitchRangeByYawRange:-1 swapYawValue:0];
					break;
				case UIDeviceOrientationPortraitUpsideDown:
					pitch = yaw;
					yaw = -swap;
					[self swapPitchRangeByYawRange:0 swapYawValue:-1];
					break;
				case UIDeviceOrientationLandscapeRight:
					pitch = -pitch;
					yaw = -yaw;
					[self swapPitchValuesWithSign:YES];
					[self swapYawValuesWithSign:YES];
					break;
			}
			break;
		//The device is in landscape mode, with the device held upright and the home button on the left side. (button left side)
		case UIDeviceOrientationLandscapeRight:
			switch(oldOrientationValue)
			{
				case UIDeviceOrientationUnknown:
				case UIDeviceOrientationPortrait:
					pitch = yaw;
					yaw = -swap;
					[self swapPitchRangeByYawRange:0 swapYawValue:-1];
					break;
				case UIDeviceOrientationPortraitUpsideDown:
					pitch = -yaw;
					yaw = swap;
					[self swapPitchRangeByYawRange:-1 swapYawValue:0];
					break;
				case UIDeviceOrientationLandscapeLeft:
					pitch = -pitch;
					yaw = -yaw;
					[self swapPitchValuesWithSign:YES];
					[self swapYawValuesWithSign:YES];
					break;
			}
			break;
	}
	rotation.pitch = pitch;
	rotation.yaw = yaw;
}
@end
