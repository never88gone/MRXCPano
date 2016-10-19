//
//  PLTexture.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLTexture.h"

@interface PLTexture()

- (BOOL)loadTextureWithObject:(id)object rotate:(int)angle;

@end

@implementation PLTexture

@synthesize textureId;
@synthesize width, height;
@synthesize row=_row;
@synthesize col=_col;
@synthesize level=_level;
@synthesize face=_face;
#pragma mark -
#pragma mark init methods

- (id)initWithImage:(UIImage *)image
{
	if(self = [super init])
		[self loadTextureWithImage:image];
	return self;
}

- (id)initWithPath:(NSString *)path
{
	if(self = [super init])
		[self loadTextureWithPath:path];
	return self;
}

- (id)initWithImage:(UIImage *)image rotate:(int) angle
{
	if(self = [super init])
		[self loadTextureWithImage:image rotate:angle];
	return self;
}

- (id)initWithPath:(NSString *)path rotate:(int)angle
{
	if(self = [super init])
		[self loadTextureWithPath:path rotate:angle];
	return self;
}

+ (id)textureWithImage:(UIImage *)image
{
	return [[PLTexture alloc] initWithImage:image];
}

+ (id)textureWithPath:(NSString *)path
{
	return [[PLTexture alloc] initWithPath:path];
}

+ (id)textureWithImage:(UIImage *)image rotate:(int)angle
{
	return [[PLTexture alloc] initWithImage:image rotate:angle];
}

+ (id)textureWithPath:(NSString *)path rotate:(int)angle;
{
	return [[PLTexture alloc] initWithPath:path rotate:angle];
}

#pragma mark -
#pragma mark load methods

- (BOOL)loadTextureWithObject:(id)object rotate:(int)angle
{
    if (object==nil) {
        return  false;
    }
	[self deleteTexture];
	
	GLint saveName;
	
	glGenTextures(1, &textureId);
	//NSLog(@"glGenTextures %d", textureId);
	glGetIntegerv(GL_TEXTURE_BINDING_2D, &saveName);
	
	glBindTexture(GL_TEXTURE_2D, textureId);
	
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE);
	
	PLImage * plImage = [object isKindOfClass:[NSString class]] ? [PLImage imageWithPath:(NSString *)object] : [PLImage imageWithCGImage:[(UIImage *)object CGImage]];
	
	width = plImage.width;
	height = plImage.height;
	_pixels = malloc(width*height*4);
    memcpy(_pixels,  (__bridge void *)object, width*height*4);
    
	if(width > kTextureMaxWidth || height > kTextureMaxHeight)
		[NSException raise:@"Invalid texture size" format:@"Texture max size is %d x %d", kTextureMaxWidth, kTextureMaxHeight];
	
	BOOL isResizableImage = NO;
	if(![PLMath isPowerOfTwo:width])
	{
		isResizableImage = YES;
		width = kTextureMaxWidth / 2;
	}
	if(![PLMath isPowerOfTwo:height])
	{
		isResizableImage = YES;
		height = kTextureMaxHeight / 2;
	}
	if(isResizableImage)
		[plImage scale:CGSizeMake(width, height)];
	
	if(angle != 0)
		[plImage rotate:angle];
	
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width , height, 0, GL_RGBA, GL_UNSIGNED_BYTE, plImage.bits);
	
	glBindTexture(GL_TEXTURE_2D, saveName);
	
	GLenum errGL = glGetError();
	
	
	if(errGL != GL_NO_ERROR)
	{
		NSLog(@"loadTexture -> glGetError = (%d) %s ...", errGL, (const char *)gluErrorString(errGL));
	}
	return YES;
}

- (BOOL)loadTextureWithPath:(NSString *)path
{
	return [self loadTextureWithPath:path rotate:0];
}

- (BOOL)loadTextureWithPath:(NSString *)path rotate:(int)angle
{
	if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:false])
		[NSException raise:@"File not exists" format:@"File %@ not exists", path];
	
	return [self loadTextureWithObject:path rotate:angle];
}

- (BOOL)loadTextureWithImage:(UIImage *)image
{
	return [self loadTextureWithImage:image rotate:0];
}

- (BOOL)loadTextureWithImage:(UIImage *)image rotate:(int)angle
{
	return [self loadTextureWithObject:image rotate:angle];
}

- (void)setTexturePlace:(int)level row:(int)row col:(int)col face:(int)face{
    self.level = level;
    self.row = row;
    self.col = col;
    self.face = face;
}
#pragma mark -
#pragma mark dealloc methods

- (void)deleteTexture
{
    //NSLog(@"deleteTexture %d", textureId);
	if(textureId)
	{
		glDeleteTextures(1, &textureId);
		textureId = 0;
	}
}


@end
