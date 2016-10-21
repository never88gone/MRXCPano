//
//  BDPanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoDataSourceBase.h"

@interface BDPanoSource : NSObject  <PanoDataSourceBase>
@property(nonatomic,strong) NSString* panoramaUrl;
@end
