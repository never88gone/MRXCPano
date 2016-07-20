//
//  PLCylinder
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSceneElement.h"

@interface PLCylinder : PLSceneElement 
{
	GLint divs;
	
	BOOL isHeightCalculated;
	GLfloat height;
}

@property(nonatomic) GLint divs;

@property(nonatomic) BOOL isHeightCalculated;
@property(nonatomic) float height;

+ (id)cylinder;
+ (id)cylinderWithTexture:(PLTexture *)texture;

@end
