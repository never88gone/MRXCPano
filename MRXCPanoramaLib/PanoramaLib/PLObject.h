//
//  PLObject.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLConstants.h"
#import "PLStructs.h"
#import "PLMath.h"

@interface PLObject : NSObject 
{
	BOOL isXAxisEnabled, isYAxisEnabled, isZAxisEnabled;
	PLPosition position;
	PLRange xRange, yRange, zRange;
	
	BOOL isPitchEnabled, isYawEnabled, isRollEnabled, isReverseRotation;
	PLRotation rotation;
	PLRange pitchRange, yawRange, rollRange;
	float rotateSensitivity;
	
	UIDeviceOrientation oldOrientation, orientation;
}

@property(nonatomic) BOOL isXAxisEnabled, isYAxisEnabled, isZAxisEnabled;
@property(nonatomic) PLPosition position;
@property(nonatomic, getter=getX, setter=setX:) float x;
@property(nonatomic, getter=getY, setter=setY:) float y;
@property(nonatomic, getter=getZ, setter=setZ:) float z;
@property(nonatomic) PLRange xRange, yRange, zRange;

@property(nonatomic) BOOL isPitchEnabled, isYawEnabled, isRollEnabled, isReverseRotation;
@property(nonatomic) PLRotation rotation;
@property(nonatomic, getter=getPitch, setter=setPitch:) float pitch;
@property(nonatomic, getter=getYaw, setter=setYaw:) float yaw;
@property(nonatomic, getter=getRoll, setter=setRoll:) float roll;
@property(nonatomic) PLRange pitchRange, yawRange, rollRange;
@property(nonatomic) float rotateSensitivity;

@property(nonatomic) UIDeviceOrientation orientation;

- (void)initializeValues;
- (void)reset;
- (float)getX;
- (void)setX:(float)value;
- (float)getY;
- (void)setY:(float)value;
- (float)getZ;
- (void)setZ:(float)value;

- (float)getPitch;
- (void)setPitch:(float)value;
- (float)getYaw;
- (void)setYaw:(float)value;
- (float)getRoll;
- (void)setRoll:(float)value;

- (void)translateWithX:(float)xValue y:(float)yValue;
- (void)translateWithX:(float)xValue y:(float)yValue z:(float)zValue;

- (void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue;
- (void)rotateWithPitch:(float)pitchValue yaw:(float)yawValue roll:(float)rollValue;
- (void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint) endPoint;
- (void)rotateWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sensitivity:(float)sensitivity;

- (void)clonePropertiesOf:(PLObject *)value;

@end
