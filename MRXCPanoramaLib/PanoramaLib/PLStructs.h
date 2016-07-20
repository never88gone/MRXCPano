//
//  PLStructs.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//
#import <UIKit/UIKit.h>
#pragma mark -
#pragma mark structs definitions

struct PLRange 
{
	CGFloat min;
	CGFloat max;
};
typedef struct PLRange PLRange;

struct PLVertex 
{
	CGFloat x, y, z;
};
typedef struct PLVertex PLVertex;
typedef struct PLVertex PLPosition;

struct PLRotation
{
	CGFloat pitch, yaw, roll;
};
typedef struct PLRotation PLRotation;

#pragma mark -
#pragma mark structs constructors

CG_INLINE PLRange
PLRangeMake(CGFloat min, CGFloat max)
{
	PLRange range = {min, max};
	return range;
}

CG_INLINE PLVertex
PLVertexMake(CGFloat x, CGFloat y, CGFloat z)
{
	PLVertex vertex = {x, y, z};
	return vertex;
}

CG_INLINE PLPosition
PLPositionMake(CGFloat x, CGFloat y, CGFloat z)
{
	PLPosition position = {x, y, z};
	return position;
}

CG_INLINE PLRotation
PLRotationMake(CGFloat pitch, CGFloat yaw, CGFloat roll)
{
	PLRotation rotation = {pitch, yaw, roll};
	return rotation;
}