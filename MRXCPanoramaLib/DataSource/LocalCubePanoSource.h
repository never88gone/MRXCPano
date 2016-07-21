//
//  LocalCubePanoSource.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PanoDataSourceBase.h"

@interface LocalCubePanoSource :  NSObject  <PanoDataSourceBase>
@property(nonatomic,strong) NSString* filePath;
@end
