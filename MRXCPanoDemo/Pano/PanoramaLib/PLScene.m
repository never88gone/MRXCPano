//
//  PLScene.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLScene.h"

@interface  PLScene()

- (void)initializeValues;

@end


@implementation PLScene

@synthesize cameras;
@synthesize currentCamera;
@synthesize cameraIndex;

@synthesize elements;

#pragma mark -
#pragma mark init methods

- (id)init
{
	if(self = [super init])
	{
		[self initializeValues];
		[self addCamera: [PLCamera camera]];
	}
	return self;
}

- (id)initWithCamera:(PLCamera *)camera
{
	if(self = [super init])
	{
		[self initializeValues];
		[self addCamera:camera];
	}
	return self;
}

- (id)initWithElement:(PLSceneElement *)element
{
	return [self initWithElement:element camera:[[PLCamera alloc] init]];
}

- (id)initWithElement:(PLSceneElement *)element camera:(PLCamera *)camera
{
	if(self = [super init])
	{
		[self initializeValues];
		[self addElement:element];
		[self addCamera:camera];
	}
	return self;
}

+ (id)scene
{
	return [[PLScene alloc] init];
}

+ (id)sceneWithCamera:(PLCamera *)camera
{
	return [[PLScene alloc] initWithCamera:camera];
}

+ (id)sceneWithElement:(PLSceneElement *)element
{
	return [[PLScene alloc] initWithElement:element];
}

+ (id)sceneWithElement:(PLSceneElement *)element camera:(PLCamera *)camera
{
	return [[PLScene alloc] initWithElement:element camera:camera];
}

- (void)initializeValues
{
	self.elements = [[NSMutableArray alloc]init];
	cameras = [[NSMutableArray alloc]init];
}

#pragma mark -
#pragma mark camera methods

- (void)setCameraIndex:(NSUInteger)index
{
	if(index < [cameras count])
	{
		cameraIndex = index;
		currentCamera = [cameras objectAtIndex:index];
	}
}

- (void)addCamera:(PLCamera *)camera
{
	if([cameras count] == 0)
	{
		cameraIndex = 0;
		currentCamera = camera;
	}
	[cameras addObject:camera];
}

- (void)removeCameraAtIndex:(NSUInteger)index
{
	[cameras removeObjectAtIndex:index];
	if([cameras count] == 0)
	{
		currentCamera = nil;
		cameraIndex = -1;
	}
}

#pragma mark -
#pragma mark element methods

- (void)addElement:(PLSceneElement *)element
{
	[elements addObject:element];
}
- (void)removeElement:(PLSceneElement *)element{
    NSLog(@"removeElement %@ \n%@", elements, element);
    [elements removeObject:elements];
}
- (void)removeElementAtIndex:(NSUInteger)index
{
	[elements removeObjectAtIndex:index];
}

@end
