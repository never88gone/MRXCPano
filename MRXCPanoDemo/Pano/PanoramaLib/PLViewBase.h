//
//  PLViewBase.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

#import "PLConstants.h"
#import "PLEnums.h"
#import "PLMath.h"
#import "PanoDataSourceBase.h"
@protocol PLViewBaseTouchEventProtocol <NSObject>

- (BOOL)singleTouchEventPoint:(CGPoint)point;

@end

@interface PLViewBase : UIView <UIAccelerometerDelegate> 
{
    //NSTimer *animationTimer;
    NSTimeInterval animationInterval;
	
	CGPoint startPoint, endPoint;
	
	BOOL isValidForFov;
	float fovDistance;
	
	BOOL isDeviceOrientationEnabled, isValidForOrientation;
	UIDeviceOrientation deviceOrientation;
	PLOrientationSupported deviceOrientationSupported;
	
	BOOL isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
	float accelerometerSensitivity;
	NSTimeInterval accelerometerInterval;
	
	BOOL isScrollingEnabled, isValidForScrolling;
	NSUInteger minDistanceToEnableScrolling;
	
	BOOL isInertiaEnabled, isValidForInertia;
	NSTimer *inertiaTimer;
	NSTimeInterval inertiaInterval;
	float inertiaStepValue;
	
	BOOL isResetEnabled;
	
	BOOL isValidForTouch;
	
	NSInteger tapCount;
    NSTimer *_panoramaTimer;
}

@property(nonatomic) NSTimeInterval animationInterval;

@property(nonatomic) BOOL isDeviceOrientationEnabled;
@property(nonatomic) UIDeviceOrientation deviceOrientation;
@property(nonatomic) PLOrientationSupported deviceOrientationSupported;

@property(nonatomic) BOOL isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
@property(nonatomic) float accelerometerSensitivity;
@property(nonatomic) NSTimeInterval accelerometerInterval;

@property(nonatomic) CGPoint startPoint, endPoint;

@property(nonatomic) BOOL isScrollingEnabled;
@property(nonatomic) NSUInteger minDistanceToEnableScrolling;

@property(nonatomic) BOOL isInertiaEnabled;
@property(nonatomic) NSTimeInterval inertiaInterval;

@property(nonatomic) BOOL isResetEnabled;
@property(assign, nonatomic)BOOL isValidForFov;
@property(strong, nonatomic)NSTimer *panoramaTimer;
@property(assign, nonatomic)id<PLViewBaseTouchEventProtocol> delegate;

- (void)allocAndInitVariables;
- (void)initializeValues;
-(void)initWithPanoType:(PanoramaCubeOrPhere)panoramaType;
- (BOOL)calculateFov:(NSSet *)touches;

- (void)reset;

- (void)drawView;
- (void)drawViewNTimes:(NSUInteger)times;

- (void)startAnimation;
- (void)stopAnimation;
+ (Class)layerClass;

@end