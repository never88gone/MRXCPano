//
//  PLView.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLView.h"

@implementation PLView
@synthesize camera;
@synthesize scene;
@synthesize sceneElement=_sceneElement;
@synthesize textures=_textures;
@synthesize sceneElements=_sceneElements;

#pragma mark -
#pragma mark init methods

- (void)allocAndInitVariables{
	[super allocAndInitVariables];
	self.scene = [PLScene scene];
	renderer = [PLRenderer rendererWithView:self scene:scene];
	camera = [PLCamera camera];
}

- (void)initializeValues{
	[super initializeValues];
	self.textures = [[NSMutableArray alloc]init];
    self.sceneElements = [[NSMutableArray alloc]init];
	camera.fovFactorRange = PLRangeMake(kDefaultFovFactorMinValue, kDefaultFovFactorMaxValue);
}
-(void)initWithPanoType:(PanoramaCubeOrPhere)panoramaType
{
    if (panoramaType==PanoramaEnumCube) {
        self.sceneElement = [PLCube cube];
        [scene addElement:self.sceneElement];
    }else if (panoramaType==PanoramaEnumPhere)
    {
        self.sceneElement = [PLSphere sphere];
        [scene addElement:self.sceneElement];
    }
}
- (void)reset{
	if(camera)
		[camera reset];
	[super reset];
}

#pragma mark -
#pragma mark draw methods

- (void)drawView 
{    
	[super drawView];
    //NSLog(@"PLView drawView!");
	[self.sceneElement clonePropertiesOf:camera];
	[scene.currentCamera cloneCameraProperties:camera];
	scene.currentCamera.rotation = PLRotationMake(0.0f, 0.0f, 0.0f);
	scene.currentCamera.position = PLPositionMake(0.0f, 0.0f, 0.0f);
	
	if(!isValidForFov && !isValidForOrientation){
		//[self.sceneElement rotateWithStartPoint:startPoint endPoint:endPoint sensitivity:camera.rotateSensitivity];
        for(PLSceneElement *element in self.scene.elements){
            [element rotateWithStartPoint:startPoint endPoint:endPoint sensitivity:camera.rotateSensitivity];
        }
    }
    //NSLog(@"PLView drawView!render。。。。。。。");
	[renderer render];
//    for(PLSceneElement *element in self.scene.elements){
//        camera.rotation = PLRotationMake(element.pitch, element.yaw, element.roll);
//    }
	camera.rotation = PLRotationMake(self.sceneElement.pitch, self.sceneElement.yaw, self.sceneElement.roll);
    //NSLog(@"PLView END drawView!render。。。。。。。");
}

#pragma mark -
#pragma mark fov methods

- (BOOL)calculateFov:(NSSet *)touches
{
	if([super calculateFov:touches])
	{
		[camera addFovWithDistance:fovDistance];
		[scene.currentCamera addFovWithDistance:fovDistance];
		return YES;
	}
	return NO;
}

#pragma mark -
#pragma mark texture methods

- (void)addTexture:(PLTexture *)texture{
	[self.textures addObject:texture];
	if(self.sceneElement)
		[self.sceneElement addTexture:texture];
}
				
- (void)removeTexture:(PLTexture *)texture{
	[self.textures removeObject:texture];
	if(self.sceneElement)
		[self.sceneElement removeTexture:texture];
}
				
- (void)removeTextureAtIndex:(NSUInteger) index{
	[self.textures removeObjectAtIndex:index];
	if(self.sceneElement)
		[self.sceneElement removeTextureAtIndex:index];
}
				
- (void)removeAllTextures{
	[self.textures removeAllObjects];
	if(self.sceneElement)
		[self.sceneElement removeAllTextures];
}

#pragma mark -
#pragma mark orientation methods

- (void)orientationChanged:(UIDeviceOrientation)orientation
{
	if(camera && self.sceneElement)
	{
		camera.orientation = orientation;
		self.sceneElement.orientation = orientation;
		camera.pitchRange = self.sceneElement.pitchRange;
		camera.yawRange = self.sceneElement.yawRange;
		camera.rollRange = self.sceneElement.rollRange;
		camera.rotation = PLRotationMake(self.sceneElement.pitch, self.sceneElement.yaw, self.sceneElement.roll);
	}
}
@end
