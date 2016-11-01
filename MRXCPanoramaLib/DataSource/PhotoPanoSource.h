//
//  PhotoPanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/11/1.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "PanoDataSourceBase.h"
@interface PhotoPanoSource : NSObject <PanoDataSourceBase>
@property(nonatomic,strong) UIImage* panoImage;
@end
