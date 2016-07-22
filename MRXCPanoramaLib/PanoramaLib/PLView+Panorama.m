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
    self.isValidForFov = YES;
    self.startPoint = self.endPoint = self.self.center;
    //NSLog(@"panoramaSwitchBegan startPoint %f %f endPoint %f %f", startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    self.panoramaTimer = [NSTimer scheduledTimerWithTimeInterval:self.animationInterval target:self selector:@selector(refreshLocation) userInfo:nil repeats:YES];
}
- (void)panoramaCalculateFov:(CGFloat)deviation{
    CGPoint point1 = CGPointMake(self.startPoint.x-deviation, self.startPoint.y+deviation);
    CGPoint point2 = CGPointMake(self.endPoint.x+deviation, self.endPoint.y-deviation);
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    self.startPoint = point1;
    self.endPoint = point2;
    self.fovDistance = ABS(self.fovDistance) <= distance ? distance : -distance;
    
    [camera addFovWithDistance:self.fovDistance];
    [scene.currentCamera addFovWithDistance:self.fovDistance];
}
- (void)panoramaCalculateFov:(CGPoint)point1 point2:(CGPoint)point2{
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    self.startPoint = point1;
    self.endPoint = point2;
    self.fovDistance = ABS(self.fovDistance) <= distance ? distance : -distance;
    
    [camera addFovWithDistance:self.fovDistance];
    [scene.currentCamera addFovWithDistance:self.fovDistance];
}
- (void)refreshLocation{
    CGFloat deviation = refreshSwitch;
    if(refreshSwitch < 512.0){
        refreshSwitch = refreshSwitch*2;
    }
    CGPoint point1 = CGPointMake(self.startPoint.x-deviation, self.startPoint.y+deviation);
    CGPoint point2 = CGPointMake(self.endPoint.x+deviation, self.endPoint.y-deviation);
    float distance = [PLMath distanceBetweenPoints: point1 : point2];
    self.startPoint = point1;
    self.endPoint = point2;
    //NSLog(@"startPoint %f %f endPoint %f %f", startPoint.x, startPoint.y, endPoint.x, endPoint.y);
    self.fovDistance = ABS(self.fovDistance) <= distance ? distance : -distance;
    [camera addFovWithDistance:self.fovDistance];
    [scene.currentCamera addFovWithDistance:self.fovDistance];
}
- (void)panoramaSwitchEnd{
    if(self.panoramaTimer != nil){
        [self.panoramaTimer invalidate];
        self.panoramaTimer = nil;
    }
    self.isValidForFov = self.isValidForTouch = NO;
    self.startPoint =self. endPoint = CGPointMake(0.0f, 0.0f);
    refreshSwitch = 8.0;
}
@end
