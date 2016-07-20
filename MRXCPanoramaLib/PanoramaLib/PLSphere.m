//
//  PLSphere.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSphere.h"

@implementation PLSphere

@synthesize divs;

#pragma mark -
#pragma mark init methods

+ (id)sphere
{
	return [[PLSphere alloc] init];
}

+ (id)sphereWithTexture:(PLTexture *)texture
{
	return [[PLSphere alloc] initWithTexture:texture];
}

- (void)initializeValues
{
	[super initializeValues];
	divs = kDefaultSphereDivs;
}

#pragma mark -
#pragma mark render methods

- (void)internalRender
{		
	GLUquadric *quadratic = gluNewQuadric();
	gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, true);
		
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[textures objectAtIndex:0]).textureId);
	
	gluSphere(quadratic, 1.0f, divs, divs);
	
	gluDeleteQuadric(quadratic);
}

@end
