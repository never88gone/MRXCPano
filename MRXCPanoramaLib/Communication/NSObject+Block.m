//
//  NSObject+Block.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "NSObject+Block.h"

@implementation NSObject (Block)
- (void)performInMainThreadBlock:(void(^)())aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
        
    });
}

- (void)performInThreadBlock:(void(^)())aInThreadBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
        
    });
}
@end
