//
//  PLCamera.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//
#import "PLObject.h"

@interface PLCamera : PLObject 
{
	BOOL isFovEnabled;
	float fov, fovFactor, fovSensitivity;
	PLRange fovRange, fovFactorRange;
}

@property(nonatomic) BOOL isFovEnabled;
@property(nonatomic) float fov, fovSensitivity;
@property(nonatomic, readonly) float fovFactor;
@property(nonatomic) PLRange fovRange, fovFactorRange;

+ (id)camera;

- (void)addFovWithDistance:(float)distance;
- (void)addFovWithStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint sign:(int)sign;

- (void)cloneCameraProperties:(PLCamera *)value;

@end