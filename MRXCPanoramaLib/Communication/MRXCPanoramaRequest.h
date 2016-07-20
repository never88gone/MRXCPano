//
//  MRXCPanoramaRequest.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRXCPanoramaRequestProtocol.h"
#import "MRXCPanoramaTool.h"
#import "MRXCPanoramaRequestData.h"
#import "PanoDataSourceBase.h"
#import  <UIKit/UIKit.h>

#define _REQUEST_FAIL_PREFIX_ @"{\"fail\""

@class MRXCPanoramaConnection;

@interface MRXCPanoramaRequest : NSObject{
    NSMutableSet *_requests;
    NSMutableDictionary *_pictureDictionary;
}
@property(strong, nonatomic)NSMutableDictionary *pictureDictionary;
@property(assign, nonatomic)BOOL isIngoreNetWorkStatus;
+(MRXCPanoramaRequest *)achievePanoramaRequest;

@end

@interface MRXCPanoramaRequest (Panorama)

- (void)achievePanoByLonLat:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource  Lon:(float)lon Lat:(float)lat Tolerance:(float)tolerance;

- (void)achievePanoByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoID:(NSString *)panoID;
- (void)achievePanoThumbnailByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoID:(NSString *)panoID;
- (void)achievePanoTileByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoramaRequestData:(MRXCPanoramaRequestData *)panoramaRequestData;
- (void)achieveAdjacentPano:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoID:(NSString *)panoID;
@end