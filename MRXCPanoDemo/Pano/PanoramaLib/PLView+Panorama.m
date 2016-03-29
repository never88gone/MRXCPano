//
//  PLView+Panorama.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLView+Panorama.h"
static CGFloat refreshSwitch=8.0;

@implementation PLView(Panorama)

- (void)panoramaSwitchBegan{
    isValidForFov = YES;
    startPoint = endPoint = self.center;
    //NSLog(@"panoramaSwitchBegan startPoint %f %f endPoint %f %f", startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    self.panoramaTimer = [NSTimer scheduledTimerWithTimeInterval:animationInterval target:self selector:@selector(refreshLocation) userInfo:nil repeats:YES];
    [self stopAnimation];
    [self startAnimation];
}
- (void)panoramaCalculateFov:(CGFloat)deviation{
    CGPoint point1 = CGPointMake(startPoint.x-deviation, startPoint.y+deviation);
    CGPoint point2 = CGPointMake(endPoint.x+deviation, endPoint.y-deviation);
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    startPoint = point1;
    endPoint = point2;
    fovDistance = ABS(fovDistance) <= distance ? distance : -distance;
    
    [camera addFovWithDistance:fovDistance];
    [scene.currentCamera addFovWithDistance:fovDistance];
}
- (void)panoramaCalculateFov:(CGPoint)point1 point2:(CGPoint)point2{
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    startPoint = point1;
    endPoint = point2;
    fovDistance = ABS(fovDistance) <= distance ? distance : -distance;
    
    [camera addFovWithDistance:fovDistance];
    [scene.currentCamera addFovWithDistance:fovDistance];
}
- (void)refreshLocation{
    CGFloat deviation = refreshSwitch;
    if(refreshSwitch < 512.0){
        refreshSwitch = refreshSwitch*2;
    }
    CGPoint point1 = CGPointMake(startPoint.x-deviation, startPoint.y+deviation);
    CGPoint point2 = CGPointMake(endPoint.x+deviation, endPoint.y-deviation);
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    startPoint = point1;
    endPoint = point2;
    //NSLog(@"startPoint %f %f endPoint %f %f", startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    fovDistance = ABS(fovDistance) <= distance ? distance : -distance;
    [camera addFovWithDistance:fovDistance];
    [scene.currentCamera addFovWithDistance:fovDistance];
}
- (void)panoramaSwitchEnd{
    [self stopAnimation];
    if(self.panoramaTimer != nil){
        [self.panoramaTimer invalidate];
        self.panoramaTimer = nil;
    }
    isValidForFov = isValidForTouch = NO;
    startPoint = endPoint = CGPointMake(0.0f, 0.0f);
    refreshSwitch = 8.0;
}
@end
