//
//  NSObject+Block.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Block)
- (void)performInMainThreadBlock:(void(^)())aInMainBlock;

- (void)performInThreadBlock:(void(^)())aInThreadBlock;
@end
