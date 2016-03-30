//
//  MRXCPanoramaIDData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCPanoramaData.h"

@implementation MRXCPanoramaData
@synthesize b=_b;
@synthesize cameraNo=_cameraNo;
@synthesize gatherTime=_gatherTime;
@synthesize imageID=_imageID;
@synthesize l=_l;
@synthesize pitch=_pitch;
@synthesize roadName=_roadName;
@synthesize roll=_roll;
@synthesize routeID=_routeID;
@synthesize segmentID=_segmentID;
@synthesize segmentIndex=_segmentIndex;
@synthesize x=_x;
@synthesize y=_y;
@synthesize yaw=_yaw;
@synthesize z=_z;

+(MRXCPanoramaData *)createPanoramaIDData :(NSDictionary *)dictionary{
    MRXCPanoramaData *data = [[MRXCPanoramaData alloc]init];
    data.b = [dictionary objectForKey:@"B"];
    data.cameraNo = [dictionary objectForKey:@"CameraNo"];
    data.gatherTime = [dictionary objectForKey:@"GatherTime"];
    data.imageID = [dictionary objectForKey:@"ImageID"];
    data.l = [dictionary objectForKey:@"L"];
    data.pitch = [dictionary objectForKey:@"Pitch"];
    data.roadName = [dictionary objectForKey:@"RoadName"];
    data.roll = [dictionary objectForKey:@"Roll"];
    data.routeID = [dictionary objectForKey:@"RouteID"];
    data.segmentID = [dictionary objectForKey:@"SegmentID"];
    data.segmentIndex = [dictionary objectForKey:@"SegmentIndex"];
    data.x = [dictionary objectForKey:@"X"];
    data.y = [dictionary objectForKey:@"Y"];
    data.yaw = [dictionary objectForKey:@"Yaw"];
    data.z = [dictionary objectForKey:@"Z"];
    return data;
}
@end
