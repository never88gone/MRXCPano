//
//  UIImage+Sacle.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Sacle)
-(UIImage*)transformWidth:(CGFloat)width height:(CGFloat)height;
- (UIImage *)imageRotateRotation:(UIImageOrientation)orientation;
@end
