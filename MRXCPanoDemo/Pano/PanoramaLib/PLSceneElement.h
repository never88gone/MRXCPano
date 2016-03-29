//
//  PLSceneElement.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "glu.h"

#import "PLEnums.h"
#import "PLStructs.h"
#import "PLUtils.h"
#import "PLTexture.h"
#import "PLObject.h"

@interface PLSceneElement : PLObject 
{
	NSMutableArray * textures;
	BOOL isVisible, isValid;
}

@property(nonatomic, retain) NSMutableArray * textures;
@property(nonatomic) BOOL isVisible;
@property(nonatomic, readonly) BOOL isValid;

- (id)initWithTexture:(PLTexture *)texture;

- (NSMutableArray *)getTextures;
- (void)addTexture:(PLTexture *)texture;
- (void)removeTexture:(PLTexture *)texture;
- (void)removeTextureAtIndex:(NSUInteger)index;
- (void)removeAllTextures;

- (BOOL)render;

@end
