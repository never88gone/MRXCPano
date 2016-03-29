//
//  MRXCAdjacentPanoData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCAdjacentPanoData.h"

@implementation MRXCAdjacentPanoData
@synthesize angle=_angle;
@synthesize dstImageID=_dstImageID;
@synthesize dstImageName=_dstImageName;
@synthesize dstName=_dstName;
@synthesize linkID=_linkID;
@synthesize projectID=_projectID;
@synthesize srcImageID=_srcImageID;
@synthesize srcImageName=_srcImageName;
@synthesize x=_x;
@synthesize y=_y;
@synthesize z=_z;

+(NSArray *)parserAdjacentPanoData:(NSDictionary *)dictionary{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if([[dictionary objectForKey:@"GetAdjacentPanoResult"] isKindOfClass:[NSDictionary class]]){
        MRXCAdjacentPanoData *data = [MRXCAdjacentPanoData createAdjacentPanoData:[dictionary objectForKey:@"GetAdjacentPanoResult"]];
        [array addObject:data];
    }
    if([[dictionary objectForKey:@"GetAdjacentPanoResult"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *dict in (NSArray *)[dictionary objectForKey:@"GetAdjacentPanoResult"]){
            MRXCAdjacentPanoData *data = [MRXCAdjacentPanoData createAdjacentPanoData:dict];
            [array addObject:data];
        }
    }
    return array;
}
+(MRXCAdjacentPanoData *)createAdjacentPanoData:(NSDictionary *)dictionary{
    MRXCAdjacentPanoData *data = [[MRXCAdjacentPanoData alloc]init];
    data.angle = [dictionary objectForKey:@"Angle"];
    data.dstImageID = [dictionary objectForKey:@"DstImageID"];
    data.dstImageName = [dictionary objectForKey:@"DstImageName"];
    data.dstName = [dictionary objectForKey:@"DstName"];
    data.linkID = [dictionary objectForKey:@"LinkID"];
    data.projectID = [dictionary objectForKey:@"ProjectID"];
    data.srcImageID = [dictionary objectForKey:@"SrcImageID"];
    data.srcImageName = [dictionary objectForKey:@"SrcImageName"];
    data.x = [dictionary objectForKey:@"X"];
    data.y = [dictionary objectForKey:@"Y"];
    data.z = [dictionary objectForKey:@"Z"];
    return data;
}
@end
