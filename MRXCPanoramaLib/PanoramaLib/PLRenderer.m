//
//  PLRenderer.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLRenderer.h"

@class PLView;

@interface PLRenderer ()

@property (nonatomic, retain) EAGLContext *context;

- (void)initializeValues;

- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;

@end

@implementation PLRenderer

@synthesize context;
@synthesize backingWidth, backingHeight;
@synthesize view;
@synthesize scene;
@synthesize currentOrientation;

#pragma mark -
#pragma mark init methods

- (id)initWithView:(PLViewBase *)aView scene:(PLScene *)aScene;
{
	if(self = [self init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
		
		if (!context || ![EAGLContext setCurrentContext:context]) 
		{
            return nil;
        }
		
		self.view = aView;
		self.scene = aScene;
		[self.view setMultipleTouchEnabled:YES];
		[self destroyFramebuffer];
		[self createFramebuffer];
	}
	return self;
}

+ (id)rendererWithView:(PLViewBase *)view scene:(PLScene *)scene
{
	return [[PLRenderer alloc] initWithView:view scene:scene];
}

- (void)initializeValues
{
	currentOrientation = UIDeviceOrientationUnknown;
}

#pragma mark -
#pragma mark buffer methods

- (BOOL)createFramebuffer 
{
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)view.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (kUseDepthBuffer) 
	{
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) 
	{
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void)destroyFramebuffer 
{
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    if(depthRenderbuffer) 
	{
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

#pragma mark -
#pragma mark render methods

- (void)render
{
	[self renderWithDeviceOrientation:view.deviceOrientation];
}

- (void)renderNTimes:(NSUInteger)times
{
	for(int i = 0; i < times; i++)
		[self render];
}

- (void)renderWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation
{
	[EAGLContext setCurrentContext:context];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);
	
	glMatrixMode(GL_PROJECTION);
	
	glLoadIdentity();
	
	glTranslatef(0.0f, 0.0f, 0.0f);
	
	PLCamera * camera = scene.currentCamera;
	
	float zoomFactor = camera.isFovEnabled ? camera.fovFactor : 1.0f ;
	
	glClear(GL_DEPTH_BUFFER_BIT | GL_COLOR_BUFFER_BIT);
	
	gluPerspective(280.0f * zoomFactor, (1.0f*backingWidth)/(1.0f*backingHeight), 0.0f, 1.0f);
	
	float portraitAngle = 90.0f;
	float landscapeAngle = 0.0f;
	
    NSUInteger device = deviceOrientation;
	switch (device)
	{
		//The device is in portrait mode but upside down, with the device held upright and the home button at the top. (normal mirror)
		case UIDeviceOrientationPortraitUpsideDown:
			portraitAngle = -portraitAngle;
			glRotatef(180.0f, 0.0f, 1.0f, 0.0f);
			break;
		//The device is in landscape mode, with the device held upright and the home button on the right side. (button right side)
		case UIDeviceOrientationLandscapeLeft:
			landscapeAngle = -90.0f;
			break;
		//The device is in landscape mode, with the device held upright and the home button on the left side. (button left side)
		case UIDeviceOrientationLandscapeRight:
			landscapeAngle = 90.0f;
			break;
	}
	
	glRotatef(portraitAngle, 1.0f, 0.0f, 0.0f);
	if(landscapeAngle != 0.0f)
		glRotatef(landscapeAngle, 0.0f, 1.0f, 0.0f);
	//NSLog(@"renderWithDeviceOrientation......begin render");
	for(PLSceneElement * element in scene.elements)
	{
		if(currentOrientation != deviceOrientation)
			element.orientation = deviceOrientation;
		[element render];
	}
	//NSLog(@"renderWithDeviceOrientation......render");
	if(currentOrientation != deviceOrientation)
		currentOrientation = deviceOrientation;
	
	glTranslatef(camera.isXAxisEnabled ? camera.x : 0.0f, camera.isYAxisEnabled ? camera.y : 0.0f, camera.isZAxisEnabled ? camera.z : 0.0f);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	if(landscapeAngle == 0)
	{
		if(camera.isPitchEnabled)
			glRotatef( (portraitAngle > 0.0f ? camera.pitch : -camera.pitch) * (camera.isReverseRotation ? -1.0f : 1.0f) , 1.0f, 0.0f, 0.0f);
		if(camera.isYawEnabled)
			glRotatef( (portraitAngle > 0.0f ? camera.yaw : -camera.yaw) * (camera.isReverseRotation ? -1.0f : 1.0f) , 0.0f, 0.0f, 1.0f );
	}
	else
	{
		if(camera.isPitchEnabled)
			glRotatef( (landscapeAngle > 0.0f ? -camera.yaw : camera.yaw) * (camera.isReverseRotation ? -1.0f : 1.0f) , 1.0f, 0.0f, 0.0f );
		if(camera.isYawEnabled)
			glRotatef( (landscapeAngle > 0.0f ? camera.pitch : -camera.pitch) * (camera.isReverseRotation ? -1.0f : 1.0f) , 0.0f, 0.0f, 1.0f );
	}
	if(camera.isRollEnabled)
		glRotatef( camera.roll  * (camera.isReverseRotation ? -1.0f : 1.0f) , 0.0f, 1.0f, 0.0f );
	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)renderNTimesWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation times:(NSUInteger)times
{
	for(int i = 0; i < times; i++)
		[self renderWithDeviceOrientation:deviceOrientation];
}
@end
