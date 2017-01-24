//
//  PLArrow.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLArrow.h"
#define _arrow_coordinate_ 0.03f

@interface PLArrow (private)
- (void)gluProjectPoint;
- (void)calculatePoint:(GLfloat *)minx miny:(GLfloat *)miny maxx:(GLfloat *)maxx maxy:(GLfloat *)maxy x:(GLfloat)x y:(GLfloat)y;
@end

@implementation PLArrow
@synthesize imageID=_imageID;
@synthesize angle=_angle;
@synthesize minPoint=_minPoint;
@synthesize maxPoint=_maxPoint;
@synthesize deviation=_deviation;
@synthesize isDelete=_isDelete;

- (void)evaluateIfElementIsValid{
    isValid = ([textures count] >= 1);
}
- (void)internalRender{
    GLfloat arrow[] = {
        -_arrow_coordinate_,  -0.15f, 0.25f,
        _arrow_coordinate_,  -0.15f, 0.25f,
        -_arrow_coordinate_,  -0.15f, 0.31f,
        _arrow_coordinate_,  -0.15f, 0.31f
    };
    GLfloat textureCoords[] ={
        0.0f, 0.0f,
        1.0f, 0.0f,
        0.0f, 1.0f,
        1.0f, 1.0f
    };
    glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
    //glTranslatef(0.0f, 0.0f, 0.25f);
    CGFloat angle = self.angle*180.0/3.14f + self.deviation;//-90.0f;
    if(angle > 360.0){
        angle = angle - 360.0;
    }
    if(angle < 0.0){
        angle = angle + 360.0;
    }
   // if(angle > 180.0){
    //    angle = 360.0-angle;
   // }
   // else{
   //     angle = -1*angle;
   // }
    if(self.isDelete == true){
        return;
    }
    //NSLog(@"[%f]angle %f---[%f]--[%f]", self.angle,angle,self.angle*180.0/3.14f + self.deviation,self.deviation);
    glRotatef(angle, 0.0f, 1.0f, 0.0f);
    glClearDepthf(1.0f);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_CULL_FACE);
    glEnable(GL_ALPHA_TEST);
    glCullFace(GL_FRONT);
    glShadeModel(GL_SMOOTH);
    
    glVertexPointer(3, GL_FLOAT, 0, arrow);
    glTexCoordPointer(2, GL_FLOAT, 0, textureCoords);
    glEnableClientState(GL_VERTEX_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
    glAlphaFunc(GL_GREATER, 0.7f);
    glBindTexture(GL_TEXTURE_2D, ((PLTexture *)[textures objectAtIndex:0]).textureId);
    glNormal3f(0.0f, -1.0f, 0.0f);
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glDisableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    glFlush();
    [self gluProjectPoint];
}
- (void)gluProjectPoint{
    GLint viewport[4];
    GLfloat modelview[16];
    GLfloat projection[16];
    GLfloat winX, winY, winZ;
    glGetIntegerv(GL_VIEWPORT, viewport);
    //    GLint temp = viewport[2];
    //    viewport[2] = viewport[3];
    //    viewport[3] = temp;
    glGetFloatv(GL_MODELVIEW_MATRIX, modelview);
    glGetFloatv(GL_PROJECTION_MATRIX, projection);
    GLfloat minx,maxx,miny,maxy,x,y,z;
    minx=maxx=miny=maxy=x=y=z=0.0;
    winX = -_arrow_coordinate_;
    winY =  -0.15;
    winZ = 0.25;
    gluProject(winX, winY, winZ, modelview, projection, viewport, &minx, &miny, &z);
    maxx = minx;
    miny = viewport[3]-miny;
    maxy = miny;
    
    winX = _arrow_coordinate_;
    winY =  -0.15;
    winZ = 0.25;
    gluProject(winX, winY, winZ, modelview, projection, viewport, &x, &y, &z);
    [self calculatePoint:&minx miny:&miny maxx:&maxx maxy:&maxy x:x y:viewport[3]-y];
    
    winX = -_arrow_coordinate_;
    winY =  -0.15;
    winZ = 0.31;
    gluProject(winX, winY, winZ, modelview, projection, viewport, &x, &y, &z);
    [self calculatePoint:&minx miny:&miny maxx:&maxx maxy:&maxy x:x y:viewport[3]-y];
    
    winX = _arrow_coordinate_;
    winY =  -0.15;
    winZ = 0.31;
    gluProject(winX, winY, winZ, modelview, projection, viewport, &x, &y, &z);
    [self calculatePoint:&minx miny:&miny maxx:&maxx maxy:&maxy x:x y:viewport[3]-y];
    
    self.minPoint = CGPointMake(minx, miny);
    self.maxPoint = CGPointMake(maxx, maxy);
}
- (void)calculatePoint:(GLfloat *)minx miny:(GLfloat *)miny maxx:(GLfloat *)maxx maxy:(GLfloat *)maxy x:(GLfloat)x y:(GLfloat)y{
    if(*minx > x){
        *minx = x;
    }
    else{
        if(*maxx < x){
            *maxx = x;
        }
    }
    if(*miny > y){
        *miny = y;
    }
    else{
        if(*maxy < y){
            *maxy = y;
        }
    }
}
@end
