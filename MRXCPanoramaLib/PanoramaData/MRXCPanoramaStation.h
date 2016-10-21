//
//  MRXCPanoramaIDData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCValueObject.h"

@interface MRXCPanoramaStation : MRXCValueObject
@property(strong, nonatomic)NSString *ImageID;
@property(strong, nonatomic)NSNumber *X;
@property(strong, nonatomic)NSNumber *Y;
@property(strong, nonatomic)NSNumber *Z;
@property(strong, nonatomic)NSNumber *Yaw;
@property(strong, nonatomic)NSNumber *Roll;
@property(strong, nonatomic)NSNumber *Pitch;
@property(strong, nonatomic)NSString *SegmentID ;
@property(strong, nonatomic)NSNumber *SegmentIndex;
@end
