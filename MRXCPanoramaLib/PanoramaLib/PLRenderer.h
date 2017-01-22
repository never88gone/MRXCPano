//
//  PLRenderer.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <QuartzCore/CAEAGLLayer.h>

#import "glu.h"

#import "PLStructs.h"
#import "PLCamera.h"
#import "PLScene.h"
#import "PLSceneElement.h"
#import "PLViewBase.h"

@interface PLRenderer : NSObject 
{
    EAGLContext *context;
	
	GLint backingWidth, backingHeight;
    
    GLuint viewRenderbuffer, viewFramebuffer, depthRenderbuffer;
	
	PLViewBase * view;
	PLScene * scene;
	
	UIDeviceOrientation currentOrientation;
}

@property (nonatomic, readonly) GLint backingWidth, backingHeight;
@property (nonatomic, strong) PLViewBase * view;
@property (nonatomic, strong) PLScene * scene;
@property (nonatomic, readonly) UIDeviceOrientation currentOrientation;

- (id)initWithView:(PLViewBase *)view scene:(PLScene *)scene;

+ (id)rendererWithView:(PLViewBase *)view scene:(PLScene *)scene;

- (void)render;
- (void)renderNTimes:(NSUInteger)times;
- (void)renderWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)renderNTimesWithDeviceOrientation:(UIDeviceOrientation)deviceOrientation times:(NSUInteger)times;
-(UIImage *)getImageFromView;
@end
