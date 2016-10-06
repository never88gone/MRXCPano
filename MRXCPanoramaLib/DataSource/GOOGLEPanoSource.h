//
//  GOOGLEPanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/3.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoDataSourceBase.h"

/**
 GOOGLE的街景数据
 */
@interface GOOGLEPanoSource : NSObject  <PanoDataSourceBase>
@property(nonatomic,strong) NSString* panoramaUrl;
@end