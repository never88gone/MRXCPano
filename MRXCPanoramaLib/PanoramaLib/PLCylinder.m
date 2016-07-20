//
//  PLCylinder.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//
#import "PLCylinder.h"

@implementation PLCylinder

@synthesize divs;

@synthesize isHeightCalculated;
@synthesize height;

#pragma mark -
#pragma mark init methods

+ (id)cylinder
{
	return [[PLCylinder alloc] init];
}

+ (id)cylinderWithTexture:(PLTexture *)texture
{
	return [[PLCylinder alloc] initWithTexture:texture];
}

- (void)initializeValues
{
	[super initializeValues];
	height = kDefaultCylinderHeight;
	divs = kDefaultCylinderDivs;
	isHeightCalculated = kDefaultCylinderHeightCalc;
	pitchRange = PLRangeMake(0.0f, 0.0f);
	isXAxisEnabled = NO;
}

#pragma mark -
#pragma mark render methods

- (void)internalRender
{	
	glTranslatef(0.0f, 0.0f, -height/2.0f);
	
	GLUquadric *quadratic = gluNewQuadric();
	gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, true);
	
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[textures objectAtIndex:0]).textureId);
	
	gluCylinder(quadratic, height/1.2f, height/1.2f, height, divs, divs);
	
	gluDeleteQuadric(quadratic);
}

#pragma mark -
#pragma mark texture methods

- (void)addTexture:(PLTexture *)texture
{
	[super addTexture:texture];
	if([textures count] == 1 && isHeightCalculated)
	{
		int textureWidth = texture.width;
		int textureHeight = texture.height;
		height = textureWidth >= textureHeight ? (float) textureWidth / textureHeight : (float) textureHeight / textureWidth;
	}
}

#pragma mark -
#pragma mark property methods

- (void)setHeight:(float)value
{
	height = ABS(value);
}

@end
