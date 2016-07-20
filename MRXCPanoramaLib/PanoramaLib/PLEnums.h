//
//  PLEnums.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

typedef enum 
{
	PLViewTypeUnknown = 0,
	PLViewTypeCylindrical,
	PLViewTypeSpherical,
	PLViewTypeCubeFaces
} PLViewType;

typedef enum 
{
	PLOrientationUnknown = 0,
	PLOrientationPortrait,
	PLOrientationLandscape
} PLOrientation;


typedef enum 
{
    PLOrientationSupportedPortrait = 1,            // Device oriented vertically, home button on the bottom
    PLOrientationSupportedPortraitUpsideDown = 2,  // Device oriented vertically, home button on the top
    PLOrientationSupportedLandscapeLeft = 4,       // Device oriented horizontally, home button on the right
    PLOrientationSupportedLandscapeRight = 8,      // Device oriented horizontally, home button on the left
	PLOrientationSupportedAll = 15
} PLOrientationSupported;