//
//  PLArrow.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "PLSceneElement.h"

@interface PLArrow : PLSceneElement{
    NSString *_imageID;
}
@property(strong, nonatomic)NSString *imageID;
@property(assign, nonatomic)CGFloat angle;
@property(assign, nonatomic)CGPoint minPoint;
@property(assign, nonatomic)CGPoint maxPoint;
@property(assign, nonatomic)CGFloat deviation;
@property(assign, nonatomic)BOOL isDelete;
@end
