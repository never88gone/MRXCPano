//
//  PLSphere.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSceneElement.h"

@interface PLSphere : PLSceneElement 
{
	GLint divs;
}

@property(nonatomic) GLint divs;

+ (id)sphere;
+ (id)sphereWithTexture:(PLTexture *)texture;

@end
