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
    if (completionBlock) {
        completionBlock(self.panoImage,nil);
    }
}

-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumPhere;
}

@end
