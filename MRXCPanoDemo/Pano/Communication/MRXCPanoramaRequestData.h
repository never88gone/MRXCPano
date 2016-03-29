//
//  MRXCPanoramaRequestData.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

#define _PANORAMA_LEVEL_ 2

@interface MRXCPanoramaRequestData : NSObject{
    NSString *_panoramaID;
}
@property(strong, nonatomic)NSString *panoramaID;
@property(assign, nonatomic)NSInteger level;
@property(assign, nonatomic)NSInteger face;
@property(assign, nonatomic)NSInteger row;
@property(assign, nonatomic)NSInteger col;

+ (id)panoramaRequestData:(NSString *)panoramaID level:(NSInteger)level face:(NSInteger)face row:(NSInteger)row col:(NSInteger)col;
@end
