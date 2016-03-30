//
//  PanoDataSourceBase.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRXCBuildURL.h"
#import "MRXCPanoramaData.h"
#import "JSON.h"
typedef NS_ENUM(NSInteger, PanoramaCubeOrPhere){
    PanoramaEnumCube,
    PanoramaEnumPhere
};
@interface PanoDataSourceBase : NSObject

@property(nonatomic,strong) NSString* panoramaUrl;

- (NSURLRequest *)achievePanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance;
- (NSURLRequest *)achievePanoByID:(NSString *)panoID;
- (NSURLRequest *)achievePanoThumbnailByID:(NSString *)panoID;
- (NSURLRequest *)achievePanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col;
- (NSURLRequest *)achieveAdjacentPano:(NSString *)panoID;
-(MRXCPanoramaData*)getPanoramaDataByResponse:(NSString *)response;
-(PanoramaCubeOrPhere)getPanoramaType;
@end
