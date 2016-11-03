//
//  PhotoPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/11/1.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "PhotoPanoSource.h"

@implementation PhotoPanoSource
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
    float oneheight=self.panoImage.size.height;
    float oneWidth=self.panoImage.size.height;
    UIImage *  leftRectImage=[MRXCPanoramaTool imageInRect:self.panoImage x:0 y:0 width:oneWidth height:oneheight];
    UIImage *fontRectImage =[MRXCPanoramaTool imageInRect:self.panoImage x:oneWidth y:0 width:oneWidth height:oneheight];
    UIImage *rightRectImage =[MRXCPanoramaTool imageInRect:self.panoImage x:oneWidth*2 y:0 width:oneWidth height:oneheight];
    UIImage *backImage = [MRXCPanoramaTool imageInRect:self.panoImage x:oneWidth*3 y:0 width:oneWidth height:oneheight];
    UIImage *  topRectImage = [MRXCPanoramaTool imageInRect:self.panoImage x:0 y:0 width:oneWidth height:oneheight];
    UIImage *  bottomRectImage = [MRXCPanoramaTool imageInRect:self.panoImage x:0 y:0 width:oneWidth height:oneheight];
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
