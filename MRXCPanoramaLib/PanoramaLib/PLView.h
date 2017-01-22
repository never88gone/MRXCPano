//
//  PLView.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PLMath.h"
#import "PLEnums.h"

#import "PLViewBase.h"
#import "PLRenderer.h"
#import "PLCamera.h"
#import "PLScene.h"
#import "PLSceneElement.h"
#import "PLTexture.h"

#import "PLCylinder.h"
#import "PLSphere.h"
#import "PLCube.h"
#import "PLArrow.h"

@interface PLView : PLViewBase {
	PLRenderer *renderer;
	PLScene *scene;
	PLCamera *camera;
	PLSceneElement *_sceneElement;
    NSMutableArray *_sceneElements;
	NSMutableArray *_textures;
}

@property(nonatomic, readonly) PLCamera *camera;
@property(retain, nonatomic)PLScene *scene;
@property(retain, nonatomic)PLSceneElement *sceneElement;
@property(retain, nonatomic)NSMutableArray *textures;
@property(retain, nonatomic)NSMutableArray *sceneElements;

- (void)addTexture:(PLTexture *)texture;
- (void)removeTexture:(PLTexture *)texture;
- (void)removeTextureAtIndex:(NSUInteger)index;
- (void)removeAllTextures;
-(UIImage *)getImageFromView;
@end
