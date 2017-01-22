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

@property (nonatomic, assign) NSInteger tapCount;
@property (nonatomic, assign) BOOL isValidForTouch;
@property (nonatomic, assign) float inertiaStepValue;
@property (nonatomic, strong) NSTimer *inertiaTimer;
@property (nonatomic, assign) BOOL isValidForInertia;
@property (nonatomic, assign) BOOL isValidForScrolling;
@property (nonatomic, assign) BOOL isValidForOrientation;

@property (nonatomic, assign) float fovDistance;
@property (nonatomic, strong) NSTimer *animationTimer;


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
+ (Class)layerClass;

@end
