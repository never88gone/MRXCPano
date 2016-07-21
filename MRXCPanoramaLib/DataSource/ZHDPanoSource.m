//
//  ZHDPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "ZHDPanoSource.h"
#import "MRXCPanoramaTool.h"
#import "MRXCHttpHelper.h"
#import "MRXCPanoramaRoadLink.h"

@implementation ZHDPanoSource

- (void)getPanoStationByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoByLonLat?lon=%f&lat=%f&tolerance=%f", self.panoramaUrl,lon,lat,tolerance];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        NSString* response=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:response];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];
}
- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoByID?imageID=%@", self.panoramaUrl, (panoID == nil) ? @"" : panoID ];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        NSString* response=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:response];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];

}
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoTile?TileID=%@%%2D1%%2D0%%2D0%%2D0%%2D0", self.panoramaUrl, [MRXCPanoramaTool achieveURLCodeString:panoID]];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
    
}
- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoTile?TileID=%@%%2D1%%2D%d%%2D%d%%2D%d%%2D%d", self.panoramaUrl, [MRXCPanoramaTool achieveURLCodeString:panoID], face, level, row, col];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
}
- (void)getLinkStationS:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetAdjacentPano?ImageID=%@", self.panoramaUrl, [MRXCPanoramaTool achieveURLCodeString:panoID]];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        NSString* response=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSArray<MRXCPanoramaRoadLink*> * panoramaDataList=[self getPanoramaListDataByResponse:response];
        if (completionBlock) {
            completionBlock(panoramaDataList,anError);
        }
    }];
    
}

-(MRXCPanoramaStation*)getPanoramaDataByResponse:(NSString*)response
{
    NSDictionary* jsonDic = [MRXCPanoramaTool formatToDicWithJsonStr:response];
    NSDictionary* panoDic= jsonDic[@"GetPanoByIDResult"];
    NSError* error=nil;
    MRXCPanoramaStation* panoramaData =[[MRXCPanoramaStation alloc] initWithDictionary:panoDic error:&error];
    return panoramaData;
}

-(NSArray<MRXCPanoramaRoadLink*>*)getPanoramaListDataByResponse:(NSString*)response
{
    NSDictionary* jsonDic = [MRXCPanoramaTool formatToDicWithJsonStr:response];
    NSArray* panoArray= jsonDic[@"GetAdjacentPanoResult"];
    NSError* error=nil;
    NSArray<MRXCPanoramaRoadLink*> * panoramaDataList =[MRXCPanoramaRoadLink arrayOfModelsFromDictionaries:panoArray error:&error];
    return panoramaDataList;
}
-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
@end
