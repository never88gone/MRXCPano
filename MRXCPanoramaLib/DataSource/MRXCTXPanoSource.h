//
//  MRXCTXPanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/3.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoDataSourceBase.h"

/**
 铭若星晨下载腾讯的地图数据发布的服务
 */
@interface MRXCTXPanoSource :NSObject  <PanoDataSourceBase>
@property(nonatomic,strong) NSString* panoramaUrl;
@end
