//
//  MRXCPanoramaRequestData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCPanoramaRequestData.h"

@implementation MRXCPanoramaRequestData
@synthesize panoramaID=_panoramaID;
@synthesize level=_level;
@synthesize face=_face;
@synthesize row=_row;
@synthesize col=_col;

+ (id)panoramaRequestData:(NSString *)panoramaID level:(NSInteger)level face:(NSInteger)face row:(NSInteger)row col:(NSInteger)col{
    MRXCPanoramaRequestData *data = [[MRXCPanoramaRequestData alloc]init];
    data.panoramaID = panoramaID;
    data.level = level;
    data.face = face;
    data.row = row;
    data.col = col;
    return data;
}
@end
