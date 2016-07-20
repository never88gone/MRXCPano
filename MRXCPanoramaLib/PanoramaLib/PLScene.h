//
//  PLScene.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLCamera.h"
#import "PLSceneElement.h"

@interface PLScene : NSObject 
{
	NSMutableArray * cameras;
	PLCamera * currentCamera;
	NSUInteger cameraIndex;
	
	NSMutableArray * elements;
}

@property (nonatomic, readonly) NSMutableArray * cameras;
@property (nonatomic, readonly) PLCamera * currentCamera;
@property (nonatomic) NSUInteger cameraIndex;

@property (nonatomic, retain) NSMutableArray * elements;

- (id)initWithCamera:(PLCamera *)camera;
- (id)initWithElement:(PLSceneElement *)element;
- (id)initWithElement:(PLSceneElement *)element camera:(PLCamera *)camera;

+ (id)scene;
+ (id)sceneWithCamera:(PLCamera *)camera;
+ (id)sceneWithElement:(PLSceneElement *)element;
+ (id)sceneWithElement:(PLSceneElement *)element camera:(PLCamera *)camera;

- (void)addCamera:(PLCamera *)camera;
- (void)removeCameraAtIndex:(NSUInteger)index;

- (void)addElement:(PLSceneElement *)element;
- (void)removeElement:(PLSceneElement *)element;
- (void)removeElementAtIndex:(NSUInteger)index;

@end
