//
//  LocalMNPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//
#import "LocalMNPanoSource.h"
#import "UIImage+Sacle.h"
@implementation LocalMNPanoSource

- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    MRXCPanoramaStation* panoramaStation=[[MRXCPanoramaStation alloc]init];
    panoramaStation.ImageID=panoID;
    if (completionBlock) {
        completionBlock(panoramaStation,nil);
    }
    
}
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSMutableArray* imageArray=[NSMutableArray array];
    UIImage *  leftRectImage = [UIImage imageNamed:@"l.jpg"];
    UIImage *fontRectImage =[UIImage imageNamed:@"f.jpg"];;
    UIImage *rightRectImage =[UIImage imageNamed:@"r.jpg"];;
    UIImage *backImage = [UIImage imageNamed:@"b.jpg"];;
    UIImage *  topRectImage = [UIImage imageNamed:@"u.jpg"];
    UIImage *  bottomRectImage = [UIImage imageNamed:@"d.jpg"];
    [imageArray addObject:rightRectImage];
    [imageArray addObject:leftRectImage];
    [imageArray addObject:backImage  ];
    [imageArray addObject:fontRectImage];
    [imageArray addObject:topRectImage];
    [imageArray addObject:bottomRectImage];
    
    if (completionBlock) {
        completionBlock(imageArray,nil);
    }
}
-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
- (int)cubeFaceIndex:(int)tileIndex{
    switch (tileIndex) {
        case 1:
            return 3;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 4;
            break;
        case 6:
            return 5;
            break;
        default:
            break;
    }
    return tileIndex;
}
@end
