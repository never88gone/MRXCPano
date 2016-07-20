//
//  PLView+Panorama.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PLView.h"
@interface PLView(Panorama)
- (void)panoramaSwitchBegan;
- (void)panoramaCalculateFov:(CGFloat)deviation;
- (void)panoramaCalculateFov:(CGPoint)point1 point2:(CGPoint)point2;
- (void)refreshLocation;
- (void)panoramaSwitchEnd;
@end
