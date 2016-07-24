//
//  MRXCAdjacentPanoData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCValueObject.h"

@interface MRXCPanoramaRoadLink : MRXCValueObject
@property(strong, nonatomic) NSNumber *Angle;
@property(strong, nonatomic)NSString *DstImageID;
@property(strong, nonatomic)NSString *DstName;
@property(strong, nonatomic)NSString *SrcImageID;

@end
