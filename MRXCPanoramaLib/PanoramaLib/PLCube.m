//
//  PLCube.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLCube.h"

#define _cube_coordinate_ 1.0f

static GLfloat cube[] =
{
    // Front Face
    -_cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    _cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    _cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    //back Face
    -_cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    // Left Face
    -_cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    -_cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    // Right Face
    _cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    _cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    // Top Face
    _cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    -_cube_coordinate_,  _cube_coordinate_,  _cube_coordinate_,
    // Bottom Face
    -_cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    -_cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_,
    _cube_coordinate_, -_cube_coordinate_,  _cube_coordinate_,
    _cube_coordinate_, -_cube_coordinate_, -_cube_coordinate_
};

static GLfloat textureCoords[] =
{
    // Front Face
    0.0f, 0.0f,1.0f, 0.0f, 0.0f, 1.0f,1.0f, 1.0f,
    // Back Face
    1.0f, 0.0f,1.0f, 1.0f, 0.0f, 0.0f,0.0f, 1.0f,
    // Left Face
    1.0f, 0.0f,1.0f, 1.0f, 0.0f, 0.0f,0.0f, 1.0f,
    // Right Face
    1.0f, 0.0f,1.0f, 1.0f, 0.0f, 0.0f,0.0f, 1.0f,
    // Top Face
    //0.0f, 0.0f,1.0f, 0.0f, 0.0f, 1.0f,1.0f, 1.0f,
    0.0f, 1.0f,0.0f, 0.0f, 1.0f, 1.0f,1.0f, 0.0f,
    // Bottom Face
    0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 1.0f,1.0f, 1.0f
};
static GLfloat normal3f[] = {
    0.0f, 0.0f, 1.0f,
    0.0f, 0.0f, -1.0f,
    -1.0f, 0.0f, 0.0f,
    1.0f, 0.0f, 0.0f,
    0.0f, 1.0f, 0.0f,
    0.0f, -1.0f, 0.0f
};
@interface PLCube (private)
- (void)calculateVertexPointer:(PLTexture *)texture vertex:(GLfloat *)vertex;
- (void)calculateVertexPointerX:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow;
- (void)calculateVertexPointerY:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow;
- (void)calculateVertexPointerZ:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow;
@end

@implementation PLCube
@synthesize panoYaw=_panoYaw;
#pragma mark -
#pragma mark init methods

+ (id)cube
{
	return [[PLCube alloc] init];
}

#pragma mark -
#pragma mark utility methods

- (void)evaluateIfElementIsValid{
	isValid = ([textures count] >= 6);
}

#pragma mark -
#pragma mark render methods

- (void)internalRender{
    //NSLog(@"internalRender yaw %f", self.panoYaw);
	glRotatef(90.0f, 1.0f, 0.0f, 0.0f);
    glRotatef(self.panoYaw, 0.0f, 1.0f, 0.0f);
	glClearDepthf(1.0f);
	glEnable(GL_TEXTURE_2D);
	glEnable(GL_CULL_FACE);
	glCullFace(GL_FRONT);
	glShadeModel(GL_SMOOTH);
    for(PLTexture *texture in textures){
        GLfloat *vertex = &(cube[texture.face*3*4]);
        if(texture.level != 0){
            GLfloat subVertex[12];
            memcpy(subVertex, vertex, 12*sizeof(GLfloat));
            [self calculateVertexPointer:texture vertex:subVertex];
            vertex = subVertex;
        }
        GLfloat *texCoord = &(textureCoords[texture.face*2*4]);
        
        glVertexPointer(3, GL_FLOAT, 0, vertex);
        glTexCoordPointer(2, GL_FLOAT, 0, texCoord);
        glEnableClientState(GL_VERTEX_ARRAY);
        glEnableClientState(GL_TEXTURE_COORD_ARRAY);
        
        glBindTexture(GL_TEXTURE_2D, texture.textureId);
        GLfloat *normal = &(normal3f[texture.face*3]);
        glNormal3f(normal[0], normal[1], normal[2]);
        glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
        
        glDisableClientState(GL_VERTEX_ARRAY);
        glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    }
	glFlush ();
}
- (void)calculateVertexPointer:(PLTexture *)texture vertex:(GLfloat *)vertex{
    if(texture.face == kCubeFrontFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerY:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerY:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerX:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerX:texture vertex:vertex isRow:false];
        }
    }
    if(texture.face == kCubeBackFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerY:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerY:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerX:texture vertex:vertex isRow:false];
        }
        else{
            [self calculateVertexPointerX:texture vertex:vertex isRow:true];
        }
    }
    if(texture.face == kCubeLeftFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerY:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerY:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerZ:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerZ:texture vertex:vertex isRow:false];
        }
    }
    if(texture.face == kCubeRightFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerY:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerY:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerZ:texture vertex:vertex isRow:false];
        }
        else{
            [self calculateVertexPointerZ:texture vertex:vertex isRow:true];
        }
    }
    if(texture.face == kCubeTopFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerX:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerX:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerZ:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerZ:texture vertex:vertex isRow:false];
        }
    }
    if(texture.face == kCubeBottomFaceIndex){
        if(texture.row == 0){
            [self calculateVertexPointerX:texture vertex:vertex isRow:true];
        }
        else{
            [self calculateVertexPointerX:texture vertex:vertex isRow:false];
        }
        if(texture.col == 0){
            [self calculateVertexPointerZ:texture vertex:vertex isRow:false];
        }
        else{
            [self calculateVertexPointerZ:texture vertex:vertex isRow:true];
        }
    }
}
- (void)calculateVertexPointerX:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow{
    if(isRow == true){
        for(int i = 0; i < 4; i++){
            if(vertex[i*3] < 0.0){
                vertex[i*3] = 0.0;
            }
        }
    }
    else{
        for(int i = 0; i < 4; i++){
            if(vertex[i*3] > 0.0){
                vertex[i*3] = 0.0;
            }
        }
    }
}
- (void)calculateVertexPointerY:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow{
    if(isRow == true) {
        for(int i = 0; i < 4; i++){
            if(vertex[i*3+1] < 0.0){
                vertex[i*3+1] = 0.0;
            }
        }
    }
    else{
        for(int i = 0; i < 4; i++){
            if(vertex[i*3+1] > 0.0){
                vertex[i*3+1] = 0.0;
            }
        }
    }
}
- (void)calculateVertexPointerZ:(PLTexture *)texture vertex:(GLfloat *)vertex isRow:(BOOL)isRow{
    if(isRow == true){
        for(int i = 0; i < 4; i++){
            if(vertex[i*3+2] < 0.0){
                vertex[i*3+2] = 0.0;
            }
        }
    }
    else{
        for(int i = 0; i < 4; i++){
            if(vertex[i*3+2] > 0.0){
                vertex[i*3+2] = 0.0;
            }
        }
    }
}
@end
