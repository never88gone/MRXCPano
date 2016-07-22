//
//  PLViewBase.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLViewBase.h"
#import "NSObject+Block.h"
@interface PLViewBase ()

- (BOOL)executeDefaultAction:(NSSet *)touches;
- (BOOL)executeDefaultAction:(NSSet *)touches isFovCalculated:(BOOL)isFovCalculated;

- (void)activateAccelerometer;
- (void)deactiveAccelerometer;

- (void)startInertia;
- (void)stopInertia;
- (void)inertia;

- (void)activateOrientation;
- (void)deactiveOrientation;
- (void)changeOrientation:(UIDeviceOrientation)orientation;
- (void)orientationChanged:(UIDeviceOrientation)orientation;
- (BOOL)isOrientationValid:(UIDeviceOrientation)orientation;

@end

@implementation PLViewBase

@synthesize  tapCount;
@synthesize  isValidForTouch;
@synthesize   inertiaStepValue;
@synthesize   inertiaTimer;
@synthesize   isValidForInertia;
@synthesize   isValidForScrolling;
@synthesize   isValidForOrientation;

@synthesize   fovDistance;



@synthesize   isDeviceOrientationEnabled;
@synthesize   deviceOrientation;
@synthesize  deviceOrientationSupported;

@synthesize  isAccelerometerEnabled, isAccelerometerLeftRightEnabled, isAccelerometerUpDownEnabled;
@synthesize   accelerometerSensitivity;
@synthesize   accelerometerInterval;

@synthesize   startPoint, endPoint;

@synthesize   isScrollingEnabled;
@synthesize   minDistanceToEnableScrolling;

@synthesize   isInertiaEnabled;
@synthesize   inertiaInterval;

@synthesize   isResetEnabled;
@synthesize   isValidForFov;
@synthesize   panoramaTimer;
@synthesize   delegate;
#pragma mark -
#pragma mark init methods 

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self != nil){
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		[self allocAndInitVariables];
		[self initializeValues];
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder 
{
    
    if ((self = [super initWithCoder:coder])) 
	{
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		[self allocAndInitVariables];
		[self initializeValues];
    }
    return self;
}

- (void)allocAndInitVariables
{
}

- (void)initializeValues
{
	
	isAccelerometerEnabled = NO;
	isAccelerometerLeftRightEnabled = YES;
	isAccelerometerUpDownEnabled = NO;
	accelerometerSensitivity = kDefaultAccelerometerSensitivity;
	accelerometerInterval = kDefaultAccelerometerInterval;
	
	isDeviceOrientationEnabled = YES;
	deviceOrientationSupported = PLOrientationSupportedAll;
	
	isScrollingEnabled = NO;
	minDistanceToEnableScrolling = kDefaultMinDistanceToEnableScrolling;
	
	isInertiaEnabled = YES;
	inertiaInterval = kDefaultInertiaInterval;
	
	isValidForTouch = NO;
	
	isResetEnabled = YES;
	[self reset];
}
-(void)initWithPanoType:(PanoramaCubeOrPhere)panoramaType
{
    
}
- (void)reset
{
	[self stopInertia];
	isValidForFov = isValidForScrolling = isValidForInertia = isValidForOrientation = NO;
	startPoint = endPoint = CGPointMake(0.0f, 0.0f);
	fovDistance = 0.0f;
	if(isDeviceOrientationEnabled)
		deviceOrientation = [[UIDevice currentDevice] orientation];
}

#pragma mark -
#pragma mark layer method 

+ (Class)layerClass 
{
    return [CAEAGLLayer class];
}

#pragma mark -
#pragma mark draw methods 

- (void)drawView
{
}

- (void)drawViewNTimes:(NSUInteger)times
{
	for(int i = 0; i < times; i++)
		[self drawView];
}

- (void)layoutSubviews 
{
	[super layoutSubviews];
	[self activateOrientation];
	[self activateAccelerometer];
	[self drawViewInBack];
}

#pragma mark -
#pragma mark animation methods 

-(void)drawViewInBack
{
    [self performInThreadBlock:^{
        [self performInMainThreadBlock:^{
            [self drawView];
        }];
    }];
}


#pragma mark -
#pragma mark action methods

- (BOOL)calculateFov:(NSSet *)touches
{
	if([touches count] == 2)
	{
		CGPoint point0 = [[[touches allObjects] objectAtIndex: 0] locationInView:self];
		CGPoint point1 = [[[touches allObjects] objectAtIndex: 1] locationInView:self];
		
		float distance = [PLMath distanceBetweenPoints: point0 : point1];
		
		startPoint = point0;
		endPoint = point1;
		
		fovDistance = ABS(fovDistance) <= distance ? distance : -distance;
		NSLog(@"calculateFov fovDistance %f", fovDistance);
		return YES;
	}
	return NO;
}

- (BOOL)executeDefaultAction:(NSSet *)touches
{
	return [self executeDefaultAction: touches isFovCalculated:YES];
}

- (BOOL)executeDefaultAction:(NSSet *)touches isFovCalculated:(BOOL)isFovCalculated
{
	if(isValidForFov)
		[self calculateFov:touches];
	else
	{
		switch ([touches count]) 
		{
			case 3:
				if(isResetEnabled)
				{
//					[self reset];
//					[self drawView];
				}
				break;
			case 2:
				isValidForFov = YES;
				if(isFovCalculated)
					[self calculateFov:touches];
			default:
				return NO;
		}
	}
	return YES;
}

#pragma mark -
#pragma mark touch methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	tapCount += [touches count];
	if(isValidForFov)
		return;
	
	[self stopInertia];
	if([[touches anyObject] tapCount] == 2)
	{
		if(isValidForScrolling)
		{
			return;
		}
	}
	isValidForTouch = YES;
	
	if(![self executeDefaultAction:touches isFovCalculated:NO])
	{
		UITouch *touch = [[event allTouches] anyObject];
		CGPoint location = [touch locationInView:touch.view];
		if(CGRectContainsPoint(self.frame, location))
		{	
			startPoint = endPoint = location;
		}
	}
    
    [self drawViewInBack ];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(![self executeDefaultAction:touches])
    {
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        if(CGRectContainsPoint(self.frame, location))
            endPoint = location;
    }
[self drawViewInBack ];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	tapCount -= [touches count];
	if([touches count] == 1){
        UITouch *touch = [[event allTouches] anyObject];
        CGPoint location = [touch locationInView:touch.view];
        if([self.delegate singleTouchEventPoint:location] == true){
            //return;
        }
        if(self.panoramaTimer != nil){
            return;
        }
    }
	if(isValidForFov)
	{
		if(tapCount == 0)
		{
			isValidForFov = isValidForTouch = NO;
			startPoint = endPoint = CGPointMake(0.0f, 0.0f);
		}
	}
	else 
	{
		if(![self executeDefaultAction:touches isFovCalculated: NO])
		{
			UITouch *touch = [[event allTouches] anyObject];
			CGPoint location = [touch locationInView:touch.view];
			if(CGRectContainsPoint(self.frame, location))
			{
				endPoint = location;
				if(isScrollingEnabled)
				{
					BOOL isValidForMove = ((startPoint.x == endPoint.x && startPoint.y == endPoint.y) || [PLMath distanceBetweenPoints:startPoint :endPoint] <= minDistanceToEnableScrolling);
					if(isInertiaEnabled)
					{
						if(isValidForMove)
							isValidForTouch = NO;
						else
							[self startInertia];
					}
				}
				else
				{
					startPoint = endPoint;
				}					
			}
		}
	}
	[self drawViewInBack ];
}

#pragma mark -
#pragma mark inertia methods

- (void)startInertia
{
	[self stopInertia];
	float interval = inertiaInterval / [PLMath distanceBetweenPoints:startPoint :endPoint];
	if(interval < 0.01f)
	{
		inertiaStepValue = 0.01f / interval;
		interval = 0.01f;
	}
	else
		inertiaStepValue = 1.0f;
	inertiaTimer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(inertia) userInfo:nil repeats:YES];
}

- (void)stopInertia
{
	if(inertiaTimer)
		[inertiaTimer invalidate];
	inertiaTimer = nil;
}

- (void)inertia
{
	float m = (endPoint.y - startPoint.y) / (endPoint.x - startPoint.x);
	float b = (startPoint.y * endPoint.x - endPoint.y * startPoint.x) / (endPoint.x - startPoint.x);
	float x, y, add;
	
	if(ABS(endPoint.x - startPoint.x) >= ABS(endPoint.y - startPoint.y))
	{
		add = (endPoint.x > startPoint.x ? -inertiaStepValue : inertiaStepValue);
		x = endPoint.x + add;
		if((add > 0.0f && x > startPoint.x) || (add <= 0.0f && x < startPoint.x))
		{
			[self stopInertia];
			isValidForTouch = NO;
			return;
		}
		y = m * x + b;
	}
	else
	{
		add = (endPoint.y > startPoint.y ? -inertiaStepValue : inertiaStepValue);
		y = endPoint.y + add;
		if((add > 0.0f && y > startPoint.y) || (add <= 0.0f && y < startPoint.y))
		{
			[self stopInertia];
			isValidForTouch = NO;
			return;
		}
		x = (y - b)/m;
	}
	endPoint = CGPointMake(x, y);
	[self drawView];
}

#pragma mark -
#pragma mark accelerometer methods

- (void)setAccelerometerInterval:(NSTimeInterval)value
{
	accelerometerInterval = value;
	[self activateAccelerometer];
}

- (void)setAccelerometerSensitivity:(float)value
{
	accelerometerSensitivity = [PLMath valueInRange:value range:PLRangeMake(kAccelerometerSensitivityMinValue, kAccelerometerSensitivityMaxValue)];
}

- (void)activateAccelerometer
{
	UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
	if(accelerometer)
	{
		accelerometer.updateInterval = accelerometerInterval;
		accelerometer.delegate = self;
	}
	else
		NSLog(@"Accelerometer not running on the device!");
}

- (void)deactiveAccelerometer
{
	UIAccelerometer* accelerometer = [UIAccelerometer sharedAccelerometer];
	if(accelerometer)
		accelerometer.delegate = nil;
}
 
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	if(isValidForTouch || isValidForOrientation)
		return;
	
	if(isAccelerometerEnabled)
	{
		UIAccelerationValue x = 0, y = 0;
		float factor = kAccelerometerMultiplyFactor * accelerometerSensitivity;
		switch (deviceOrientation) 
		{
			case UIDeviceOrientationUnknown:
			case UIDeviceOrientationPortrait:
			case UIDeviceOrientationPortraitUpsideDown:
				x = (isAccelerometerLeftRightEnabled ? acceleration.x : 0.0f);
				y = (isAccelerometerUpDownEnabled ? acceleration.z : 0.0f);
				startPoint = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
				break;
			case UIDeviceOrientationLandscapeLeft:
			case UIDeviceOrientationLandscapeRight:
				x = (isAccelerometerUpDownEnabled ? -acceleration.z : 0.0f);
				y = (isAccelerometerLeftRightEnabled ? -acceleration.y : 0.0f);
				startPoint = CGPointMake(self.bounds.size.height / 2.0f, self.bounds.size.width / 2.0f);
				break;
			default:
				startPoint = CGPointMake(self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f);
				break;
		}
		endPoint = CGPointMake(startPoint.x + (x * factor), startPoint.y + (y * factor));
		[self drawView];
	}
}

#pragma mark -
#pragma mark orientation methods

- (void)setDeviceOrientation:(UIDeviceOrientation)orientation
{
	if(deviceOrientation != orientation && [self isOrientationValid:orientation])
	{
		deviceOrientation = orientation;
		[self changeOrientation: orientation];
	}
}

- (void)activateOrientation
{
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didRotate:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
}

- (void)deactiveOrientation
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

- (void)didRotate:(NSNotification *)notification
{
	if(isDeviceOrientationEnabled && [self isOrientationValid:[[UIDevice currentDevice] orientation]])
	{
		deviceOrientation = [[UIDevice currentDevice] orientation];
		[self changeOrientation: deviceOrientation];
	}
}

- (void)changeOrientation:(UIDeviceOrientation)orientation
{
	isValidForOrientation = YES;
	[self orientationChanged: orientation];
	[self drawView];
	isValidForOrientation = NO;
}

- (void)orientationChanged:(UIDeviceOrientation)orientation
{
}

- (BOOL)isOrientationValid:(UIDeviceOrientation)orientation
{
	PLOrientationSupported value;
	switch (orientation) 
	{
		case UIDeviceOrientationUnknown:
		case UIDeviceOrientationPortrait:
			value = PLOrientationSupportedPortrait;
			break;
		case UIDeviceOrientationPortraitUpsideDown:
			value = PLOrientationSupportedPortraitUpsideDown;
			break;
		case UIDeviceOrientationLandscapeLeft:
			value = PLOrientationSupportedLandscapeLeft;
			break;
		case UIDeviceOrientationLandscapeRight:
			value = PLOrientationSupportedLandscapeRight;
			break;
		default:
			return NO;
	}
	return (deviceOrientationSupported & value);
}
- (void)dealloc
{
	[self deactiveOrientation];
	[self deactiveAccelerometer];
}
@end
