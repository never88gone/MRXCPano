//
//  PLSphere.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSphere.h"
@interface PLSphere()
@property(nonatomic) NSInteger m_maxRow;
@property(nonatomic) NSInteger m_maxCol;
@property(nonatomic) NSInteger m_Radius;

@property(nonatomic) GLUquadric* quadratic;

@end
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
    self.m_maxRow = 4;
    self.m_maxCol = 8;
    self.m_Radius =1.0f;
    self.quadratic = gluNewQuadric();
    gluQuadricNormals(self.quadratic, GLU_SMOOTH);
    gluQuadricTexture(self.quadratic, YES);
    
	divs = kDefaultSphereDivs;
}

#pragma mark -
#pragma mark render methods

- (void)internalRender
{
//    glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
    glRotatef(self.panoYaw, 0.0f, 1.0f, 0.0f);
    glClearDepthf(1.0f);
    
	GLUquadric *quadratic = gluNewQuadric();
	gluQuadricNormals(quadratic, GLU_SMOOTH);
	gluQuadricTexture(quadratic, true);
		
	glEnable(GL_TEXTURE_2D);
    
	glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[textures objectAtIndex:0]).textureId);
    gluSphere(quadratic, (GLfloat)self.m_Radius, divs, divs);
    
	for(PLTexture *texture in textures){
        glBindTexture(GL_TEXTURE_2D,texture.textureId);
        int rowIdx = texture.row;
        int colIdx = texture.col;
        float left = 360.0f*((float)colIdx/(float)self.m_maxCol);
        float right = 360.0f*((float)++colIdx/(float)self.m_maxCol);
        
        float top = 180*((float)rowIdx/(float)self.m_maxRow);
        float bottom = 180*((float)++rowIdx/(float)self.m_maxRow);
        
        gluSphereCurve(self.quadratic, (GLfloat)self.m_Radius,  (GLfloat)left,  (GLfloat)right,  (GLfloat)top,  (GLfloat)bottom, 5, 5);
    }
	
	gluDeleteQuadric(quadratic);
}

@end
