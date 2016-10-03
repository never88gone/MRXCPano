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
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
         
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
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
         
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
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
         
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
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
         
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
    NSString* sqlStr=[NSString stringWithFormat:@"select * from %@ where ImageName='%@'",@"MRXC_PANO_IMAGEINFO",panoID];
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
         
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:returnResultSet];
          
        [self getLinkStationSByStation:panoramaStation CompletionBlock:^(id aResponseObject, NSError *anError) {
              
            NSMutableArray<MRXCPanoramaRoadLink*> * panoramaDataList =  [[NSMutableArray<MRXCPanoramaRoadLink*> alloc] init];
             [panoramaDataList addObjectsFromArray:[aResponseObject copy]];
              
            [self getLinkStationLinkByStation:panoramaStation CompletionBlock:^(id aResponseObject, NSError *anError) {
                 
                [panoramaDataList addObjectsFromArray:[aResponseObject copy]];
                if (completionBlock) {
                    completionBlock(panoramaDataList,anError);
                }
            }];

        }];
    }];
}

- (void)getLinkStationSByStation:(MRXCPanoramaStation *)panoramaStation CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* sqlStr=[NSString stringWithFormat:@"select * from %@ where SegmentID='%@' and SegmentIndex= %d or SegmentIndex= %d ",@"MRXC_PANO_IMAGEINFO",panoramaStation.SegmentID,panoramaStation.SegmentIndex.intValue-1,panoramaStation.SegmentIndex.intValue+1];
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        NSMutableArray<MRXCPanoramaRoadLink*> * panoramaDataList = [[ NSMutableArray<MRXCPanoramaRoadLink*>  alloc] init];
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        while ([returnResultSet next]) {
            MRXCPanoramaStation* onePanoramaData=[self getPanoramaByResultSet:returnResultSet];
            MRXCPanoramaRoadLink* oneRoadLink=[[MRXCPanoramaRoadLink alloc] init];
            oneRoadLink.SrcImageID=panoramaStation.ImageID;
            oneRoadLink.DstImageID=onePanoramaData.ImageID;
            
            oneRoadLink.Angle=@([MRXCPanoramaTool getYawByStartLon:panoramaStation.X.floatValue StartLat:panoramaStation.Y.floatValue EndLon:onePanoramaData.X.floatValue EndLat:onePanoramaData.Y.floatValue]);
            [panoramaDataList addObject:oneRoadLink];
        }
        if (completionBlock) {
            completionBlock(panoramaDataList,anError);
        }
    }];
}


- (void)getLinkStationLinkByStation:(MRXCPanoramaStation *)panoramaStation CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* sqlStr=[NSString stringWithFormat:@"select * from %@ where SrcImageName='%@' or DstImageName= '%@'",@"MRXC_PANO_LINK", panoramaStation.ImageID,panoramaStation.ImageID];
     
    [[MRXCDBHelper sharedInstance] executeQuery:sqlStr Callback:^(id aResponseObject, NSError *anError) {
        NSMutableArray<MRXCPanoramaRoadLink*> * panoramaDataList = [[ NSMutableArray<MRXCPanoramaRoadLink*>  alloc] init];
        FMResultSet* returnResultSet=(FMResultSet*)aResponseObject;
        while ([returnResultSet next]) {
             panoramaDataList=[self getPanoramaListDataByLinkResponse:returnResultSet Station:panoramaStation];

        }
        if (completionBlock) {
            completionBlock(panoramaDataList,anError);
        }
    }];
}


-(MRXCPanoramaStation*)getPanoramaByResultSet:(FMResultSet*)resultSet
{
    MRXCPanoramaStation* panoramaData =[[MRXCPanoramaStation alloc] init];
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
    return panoramaData;
}

-(MRXCPanoramaStation*)getPanoramaDataByResponse:(FMResultSet*)resultSet
{
    MRXCPanoramaStation* panoramaData =nil;
    while ([resultSet next]) {
        panoramaData=[self getPanoramaByResultSet:resultSet];
        break;
    }
    [resultSet close];
    return panoramaData;
}

-(NSArray<MRXCPanoramaRoadLink*>*)getPanoramaListDataByLinkResponse:(FMResultSet*)resultSet Station:(MRXCPanoramaStation *)panoramaStation
{
    NSMutableArray<MRXCPanoramaRoadLink*> * panoramaDataList = [[ NSMutableArray<MRXCPanoramaRoadLink*>  alloc] init];
    while ([resultSet next]) {
        MRXCPanoramaRoadLink* oneRoadLink=[[MRXCPanoramaRoadLink alloc] init];
        oneRoadLink.SrcImageID=[resultSet stringForColumn:@"SrcImageName"];
        oneRoadLink.DstImageID=[resultSet stringForColumn:@"DstImageName"];
        oneRoadLink.Angle=@([resultSet doubleForColumn:@"Direction"]);
        [panoramaDataList addObject:oneRoadLink];
    }
    [resultSet close];
    return panoramaDataList;
}


-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
@end
