//
//  MRXCAdjacentPanoData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCValueObject.h"

@interface MRXCPanoramaRoadLink : MRXCValueObject
@property(strong, nonatomic)NSString *Angle;
@property(strong, nonatomic)NSString *DstImageID;
@property(strong, nonatomic)NSString *DstImageName;
@property(strong, nonatomic)NSString *DstName;
@property(strong, nonatomic)NSString *LinkID;
@property(strong, nonatomic)NSString *ProjectID;
@property(strong, nonatomic)NSString *SrcImageID;
@property(strong, nonatomic)NSString *SrcImageName;
@property(strong, nonatomic)NSString *X;
@property(strong, nonatomic)NSString *Y;
@property(strong, nonatomic)NSString *Z;

@end
