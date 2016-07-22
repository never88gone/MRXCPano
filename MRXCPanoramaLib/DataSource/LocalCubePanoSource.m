//
//  LocalCubePanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "LocalCubePanoSource.h"

#import "MRXCPanoramaTool.h"
#import "MRXCPanoramaRoadLink.h"
#import "MRXCDBHelper.h"

@implementation LocalCubePanoSource
-(void)setFilePath:(NSString *)filePath
{
    [[MRXCDBHelper sharedInstance] initWithPath:filePath];
}
- (void)getPanoStationByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* sqlStr=nil;
    WEAK_SELF;
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:returnResultSet];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];
}
- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    
    NSString* sqlStr=[NSString stringWithFormat:@"select * from %@ where ImageName='%@'",@"MRXC_PANO_IMAGEINFO",panoID];
    WEAK_SELF;
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:returnResultSet];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];
    
}
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* sqlStr=[NSString stringWithFormat:@"select TileData from %@ where TileID='%@-2-%d-%d-%d-%d'",@"MRXC_PANO_TILEINFO",panoID,0,0,0,0];
    WEAK_SELF;
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        NSData* returnData=nil;
        while ([returnResultSet next]) {
            returnData=[returnResultSet dataForColumn:@"TileData"];
        }
        NSError* error;
        if (returnData==nil) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"data is nil"                                                                      forKey:NSLocalizedDescriptionKey];
            error=[NSError errorWithDomain:CustomErrorDomain code:-1 userInfo:userInfo];
        }
        completionBlock(returnData,error);
    }];
    
}
- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* sqlStr=[NSString stringWithFormat:@"select TileData from %@ where TileID='%@-2-%d-%d-%d-%d'",@"MRXC_PANO_TILEINFO",panoID,face,level,row,col];
    WEAK_SELF;
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        NSData* returnData=nil;
        while ([returnResultSet next]) {
            returnData=[returnResultSet dataForColumn:@"TileData"];
        }
        NSError* error;
        if (returnData==nil) {
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"data is nil"                                                                      forKey:NSLocalizedDescriptionKey];
            error=[NSError errorWithDomain:CustomErrorDomain code:-1 userInfo:userInfo];
        }
        completionBlock(returnData,error);
    }];
}
- (void)getLinkStationS:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    
//    NSString* sqlStr=nil;
//    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
//        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
//         NSArray<MRXCPanoramaRoadLink*> * panoramaDataList=[self getPanoramaDataByResponse:returnResultSet];
//        if (completionBlock) {
//            completionBlock(panoramaDataList,anError);
//        }
//    }];
}

-(MRXCPanoramaStation*)getPanoramaDataByResponse:(FMResultSet*)resultSet
{
    MRXCPanoramaStation* panoramaData =[[MRXCPanoramaStation alloc] init];
    while ([resultSet next]) {
        panoramaData.B=@([resultSet doubleForColumn:@"B"]);
        panoramaData.CameraNo=[resultSet stringForColumn:@"CameraNo"];
        panoramaData.GatherTime=[resultSet stringForColumn:@"GatherTime"];
        panoramaData.ImageID=[resultSet stringForColumn:@"ImageName"];
        panoramaData.L=@([resultSet doubleForColumn:@"L"]);
        panoramaData.Pitch=@([resultSet doubleForColumn:@"Pitch"]);
        panoramaData.Roll=@([resultSet doubleForColumn:@"Roll"]);
        panoramaData.SegmentID=[resultSet stringForColumn:@"SegmentID"];
        panoramaData.SegmentIndex=@([resultSet intForColumn:@"SegmentIndex"]);
        panoramaData.X=@([resultSet doubleForColumn:@"X"]);
        panoramaData.Y=@([resultSet doubleForColumn:@"Y"]);
        panoramaData.Yaw=@([resultSet doubleForColumn:@"Yaw"]);
        panoramaData.Z=@([resultSet doubleForColumn:@"Z"]);
    }
    [resultSet close];
    return panoramaData;
}

-(NSArray<MRXCPanoramaRoadLink*>*)getPanoramaListDataByResponse:(FMResultSet*)resultSet
{
//    NSDictionary* jsonDic = [MRXCPanoramaTool formatToDicWithJsonStr:response];
//    NSArray* panoArray= jsonDic[@"GetAdjacentPanoResult"];
//    NSError* error=nil;
//    NSArray<MRXCPanoramaRoadLink*> * panoramaDataList =[MRXCPanoramaRoadLink arrayOfModelsFromDictionaries:panoArray error:&error];
    return nil;
}
-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
@end
