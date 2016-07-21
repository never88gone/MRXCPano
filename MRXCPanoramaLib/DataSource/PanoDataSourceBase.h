//
//  PanoDataSourceBase.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRXCBuildURL.h"
#import "MRXCPanoramaStation.h"
#import "MRXCPanoramaRoadLink.h"
#import "MRXCHttpHelper.h"

typedef NS_ENUM(NSInteger, PanoramaCubeOrPhere){
    PanoramaEnumCube,
    PanoramaEnumPhere
};

@protocol PanoDataSourceBase <NSObject>
- (void)getPanoStationByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance CompletionBlock:(MRXCCompletionBlock)completionBlock;
- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock;
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock;
- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock;
- (void)getLinkStationS:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock;
-(PanoramaCubeOrPhere)getPanoramaType;
@end
