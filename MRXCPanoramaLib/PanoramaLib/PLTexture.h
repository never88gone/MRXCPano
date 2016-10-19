//
//  PLTexture.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "glu.h"

#import "PLConstants.h"
#import "PLImage.h"
#import "PLMath.h"

@interface PLTexture : NSObject {
	GLuint textureId;
	int width, height;
    int _row, _col, _level;
    int _face;
}

@property (nonatomic, readonly) GLuint textureId;
@property (nonatomic, readonly) int width, height;
@property (nonatomic, readonly)	void* pixels;
@property (assign, nonatomic) int row;
@property (assign, nonatomic) int col;
@property (assign, nonatomic) int level;
@property (assign, nonatomic) int face;

- (id)initWithImage:(UIImage *)image;
- (id)initWithPath:(NSString *)path;
- (id)initWithImage:(UIImage *)image rotate:(int)angle;
- (id)initWithPath:(NSString *)path rotate:(int)angle;

+ (id)textureWithImage:(UIImage *)image;
+ (id)textureWithPath:(NSString *)path;
+ (id)textureWithImage:(UIImage *)image rotate:(int)angle;
+ (id)textureWithPath:(NSString *)path rotate:(int)angle;
- (void)deleteTexture;
- (BOOL)loadTextureWithImage:(UIImage *)image;
- (BOOL)loadTextureWithImage:(UIImage *)image rotate:(int)angle;
- (BOOL)loadTextureWithPath:(NSString *)path;
- (BOOL)loadTextureWithPath:(NSString *)path rotate:(int)angle;

- (void)setTexturePlace:(int)level row:(int)row col:(int)col face:(int)face;
@end
