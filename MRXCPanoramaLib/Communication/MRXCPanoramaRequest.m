//
//  MRXCPanoramaRequest.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCPanoramaRequest.h"
#import "MRXCPanoramaConnection.h"
#import "MRXCBuildURL.h"
#import "MRXCPanoramaRoadLink.h"

static MRXCPanoramaRequest *request = nil;

@interface MRXCPanoramaRequest(response)

- (void)achievePanoByIDResponse:(MRXCPanoramaConnection *)connection;
- (void)achievePanoThumbnailByIDResponse:(MRXCPanoramaConnection *)connection;
- (void)achievePanoTileByIDResponse:(MRXCPanoramaConnection *)connection;
- (void)achieveAdjacentPanoResponse:(MRXCPanoramaConnection *)connection;
@end

@implementation MRXCPanoramaRequest
@synthesize pictureDictionary=_pictureDictionary;
@synthesize isIngoreNetWorkStatus=_isIngoreNetWorkStatus;

+(MRXCPanoramaRequest *)achievePanoramaRequest{
    if(request == nil)
    {
        request = [[MRXCPanoramaRequest alloc]init];
    }
    return request;
}
- (id)init{
    self = [super init];
    if(self != nil){
        _requests = [[NSMutableSet alloc]init];
        _pictureDictionary = [[NSMutableDictionary alloc]init];
    }
    return self;
}
- (void)achievePanoByLonLat:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource  Lon:(float)lon Lat:(float)lat Tolerance:(float)tolerance
{
    NSURLRequest *request = [dataSource achievePanoByLon:lon Lat:lat Tolerance:tolerance];
    MRXCPanoramaConnection *connection = [[MRXCPanoramaConnection alloc]initWithURLRequest:request target:self selector:@selector(achievePanoByIDResponse:) delegate:delegate];
    [_requests addObject:connection];
}
- (void)achievePanoByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource  PanoID:(NSString *)panoID{
    NSURLRequest *request = [dataSource achievePanoByID:panoID];
    MRXCPanoramaConnection *connection = [[MRXCPanoramaConnection alloc]initWithURLRequest:request target:self selector:@selector(achievePanoByIDResponse:) delegate:delegate];
    [_requests addObject:connection];
}
- (void)achievePanoThumbnailByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoID:(NSString *)panoID {
    NSData *picture = [self.pictureDictionary objectForKey:panoID];
    if(picture != nil){
        if([delegate respondsToSelector:@selector(achievePanoThumbnailByIDResponse:success:info:)]){
            [delegate achievePanoThumbnailByIDResponse:picture success:true info:nil];
        }
        return;
    }
    NSURLRequest *request = [dataSource achievePanoThumbnailByID:panoID];
    MRXCPanoramaConnection *connection = [[MRXCPanoramaConnection alloc]initWithURLRequest:request target:self selector:@selector(achievePanoThumbnailByIDResponse:) delegate:delegate];
    [_requests addObject:connection];
}
- (void)achievePanoTileByID:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource PanoramaRequestData:(MRXCPanoramaRequestData *)panoramaRequestData{
    NSString *key = [[NSString alloc]initWithFormat:@"%@-1-%d-%d-%d-%d", panoramaRequestData.panoramaID, panoramaRequestData.face, panoramaRequestData.level, panoramaRequestData.row, panoramaRequestData.col];
    NSData *picture = [self.pictureDictionary objectForKey:key];
    if(picture != nil){
        if([delegate respondsToSelector:@selector(achievePanoTileByIDResponse:success:info:)]){
            NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:panoramaRequestData, @"panorama", nil];
            [delegate achievePanoTileByIDResponse:picture success:true info:dictionary];
        }
        return;
    }
    NSURLRequest *request = [dataSource achievePanoTileByID:panoramaRequestData.panoramaID level:panoramaRequestData.level face:panoramaRequestData.face row:panoramaRequestData.row col:panoramaRequestData.col];
    MRXCPanoramaConnection *connection = [[MRXCPanoramaConnection alloc]initWithURLRequest:request target:self selector:@selector(achievePanoTileByIDResponse:) delegate:delegate panoramaRequestData:panoramaRequestData];
    [_requests addObject:connection];
}
- (void)achieveAdjacentPano:(id<MRXCPanoramaRequestProtocol>)delegate DataSource:(PanoDataSourceBase*)dataSource  PanoID:(NSString *)panoID{
    NSURLRequest *request = [dataSource achieveAdjacentPano:panoID];
    MRXCPanoramaConnection *connection = [[MRXCPanoramaConnection alloc]initWithURLRequest:request target:self selector:@selector(achieveAdjacentPanoResponse:) delegate:delegate];
    [_requests addObject:connection];
}



- (void)achievePanoByIDResponse:(MRXCPanoramaConnection *)connection{
    BOOL success = false;
    NSObject *object = nil;
    NSDictionary *errDictionary = nil;
    [_requests removeObject:connection];
    if([connection.response statusCode] == 200){
        NSString *response = [[NSString alloc]initWithData:connection.resultData encoding:NSUTF8StringEncoding];
        if([object isKindOfClass:[NSNull class]]){
            success = false;
        }
        else{
            success = true;
        }
        if([connection.delegate respondsToSelector:@selector(achievePanoByIDResponse:success:info:)]){
            [connection.delegate achievePanoByIDResponse:response success:success info:errDictionary];
        }
    }
}
- (void)achievePanoThumbnailByIDResponse:(MRXCPanoramaConnection *)connection{
    BOOL success = false;
    if([connection.response statusCode] == 200){
        success = true;
    }
    else{
        success = false;
    }
    [_requests removeObject:connection];
    if([connection.delegate respondsToSelector:@selector(achievePanoThumbnailByIDResponse:success:info:)]){
        [connection.delegate achievePanoThumbnailByIDResponse:connection.resultData success:success info:nil];
    }
}
- (void)achievePanoTileByIDResponse:(MRXCPanoramaConnection *)connection{
    BOOL success = false;
    if([connection.response statusCode] == 200){
        success = true;
    }
    else{
        success = false;
    }
    [_requests removeObject:connection];
    if([connection.delegate respondsToSelector:@selector(achievePanoTileByIDResponse:success:info:)]){
        NSDictionary *dictionary = [[NSDictionary alloc]initWithObjectsAndKeys:connection.panoramaData, @"panorama", nil];
        [connection.delegate achievePanoTileByIDResponse:connection.resultData success:success info:dictionary];
    }
}
- (void)achieveAdjacentPanoResponse:(MRXCPanoramaConnection *)connection{
    BOOL success = false;
    NSObject *object = nil;
    NSArray<MRXCPanoramaRoadLink*> *jsonArray = nil;
    NSDictionary *dictionary = nil;
    NSDictionary *errDictionary = nil;
    if([connection.response statusCode] == 200){
        NSString *response = [[NSString alloc]initWithData:connection.resultData encoding:NSUTF8StringEncoding];
        dictionary = [MRXCPanoramaTool formatToDicWithJsonStr:response];
        object = [dictionary objectForKey:@"GetAdjacentPanoResult"];
        if([object isKindOfClass:[NSNull class]]){
            success = false;
            errDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:@"查询无记录!",@"fail",  nil];
        }
        else{
            success = true;
            jsonArray = [MRXCPanoramaRoadLink arrayOfModelsFromDictionaries:object error:nil];
        }
    }
    [_requests removeObject:connection];
    if([connection.delegate respondsToSelector:@selector(achieveAdjacentPanoResponse:success:info:)]){
        [connection.delegate achieveAdjacentPanoResponse:jsonArray success:success info:errDictionary];
    }
}
@end
