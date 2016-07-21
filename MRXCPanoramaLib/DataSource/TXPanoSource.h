//
//  TXPanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoDataSourceBase.h"
/**
 *  腾讯的数据源
 */
@interface TXPanoSource : NSObject  <PanoDataSourceBase>
@property(nonatomic,strong) NSString* imageURlStr;
@property(nonatomic,strong) NSString* panoramaUrl;

@end
