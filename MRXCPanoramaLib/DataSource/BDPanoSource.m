//
//  BDPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "BDPanoSource.h"
@interface BDPanoSource()
@property(nonatomic,strong) NSArray<MRXCPanoramaRoadLink*>* panoramaRoadLink;
@end
@implementation BDPanoSource

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.panoramaUrl=@"http://sv0.map.baidu.com";
    }
    return self;
}

- (void)getPanoStationByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    [[MRXCHttpHelper sharedInstance] cancelAllOperations];
    NSString *baseURL=[NSString stringWithFormat:@"%@?qt=qsdata&action=1&type=all&r=1000&x=%f&y==%f", self.panoramaUrl,lon*10e5,lat*10e5];
    WEAK_SELF;
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        NSData* returnData=(NSData*)aResponseObject;
        NSString* response=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:response];
        self.panoramaRoadLink=[self getPanoramaListDataByResponse:response];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];
}
- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    [[MRXCHttpHelper sharedInstance] cancelAllOperations];
    NSString *baseURL=[NSString stringWithFormat:@"%@/?qt=sdata&sid=%@", self.panoramaUrl,panoID ];
    WEAK_SELF;
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        STRONG_SELF;
        NSData* returnData=(NSData*)aResponseObject;
        NSString* response=[[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        MRXCPanoramaStation* panoramaStation=[self getPanoramaDataByResponse:response];
        self.panoramaRoadLink=[self getPanoramaListDataByResponse:response];
        if (completionBlock) {
            completionBlock(panoramaStation,anError);
        }
    }];
    
}
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/?qt=pdata&sid=%@&pos=0_0&z=1", self.panoramaUrl, [MRXCPanoramaTool achieveURLCodeString:panoID]];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
    
}
- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/?qt=pdata&sid=%@&z=%d&pos=%d_%d", self.panoramaUrl, [MRXCPanoramaTool achieveURLCodeString:panoID], 4, row, col];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
}
- (void)getLinkStationS:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    if (completionBlock) {
        completionBlock(self.panoramaRoadLink,nil);
    }
    
}

-(MRXCPanoramaStation*)getPanoramaDataByResponse:(NSString*)response
{
    NSDictionary* jsonDic = [MRXCPanoramaTool formatToDicWithJsonStr:response];
    MRXCPanoramaStation* panoramaData =nil;
    if (jsonDic!=nil) {
        panoramaData =[[MRXCPanoramaStation alloc] init];
        NSArray* contentArray=jsonDic[@"content"];
        if (contentArray.count>0) {
            NSDictionary* oneConentDic=contentArray[0];
            panoramaData.ImageID=oneConentDic[@"ID"];
            panoramaData.Pitch=oneConentDic[@"Pitch"];
            panoramaData.Roll=oneConentDic[@"Roll"];
            panoramaData.X=oneConentDic[@"X"];
            panoramaData.Y=oneConentDic[@"Y"];
            panoramaData.Yaw=oneConentDic[@"NorthDir"];
            panoramaData.Z=oneConentDic[@"Z"];
        }
    }
    return panoramaData;
}

-(NSArray<MRXCPanoramaRoadLink*>*)getPanoramaListDataByResponse:(NSString*)response
{
    NSDictionary* jsonDic = [MRXCPanoramaTool formatToDicWithJsonStr:response];
    NSMutableArray<MRXCPanoramaRoadLink*> * panoramaDataList=[NSMutableArray<MRXCPanoramaRoadLink*> array];
    if (jsonDic!=nil) {
        NSArray* contentArray=jsonDic[@"content"];
        if (contentArray.count>0) {
            NSDictionary* oneConentDic=contentArray[0];
            NSNumber* northDir=oneConentDic[@"NorthDir"];
            NSNumber* moveDir=oneConentDic[@"MoveDir"];
            NSNumber* heading=oneConentDic[@"Heading"];
            
            NSString* srcPID=oneConentDic[@"ID"];
            NSArray* roadsDic=oneConentDic[@"Roads"];
            for (int i=0; i<roadsDic.count; i++) {
                NSDictionary* oneRoadDic=roadsDic[i];
                NSArray* panoArray=oneRoadDic[@"Panos"];
                NSInteger selectIndex=-1;
                for (int j=0; j<panoArray.count; j++)  {
                    NSDictionary* onePanoDic=panoArray[j];
                    NSString* onePID=onePanoDic[@"PID"];
                    if ([onePID isEqualToString:srcPID]) {
                        selectIndex=[onePanoDic[@"Order"] integerValue];
                        break;
                    }
                }
                
            for (int j=0; j<panoArray.count; j++)  {
                NSDictionary* nextLinkDic=panoArray[j];
                NSInteger curIndex=[nextLinkDic[@"Order"] integerValue];
                if (curIndex==selectIndex-1||curIndex==selectIndex+1) {
                    MRXCPanoramaRoadLink* nextPanoramaRoadLink=[[MRXCPanoramaRoadLink alloc] init];
                    nextPanoramaRoadLink.SrcImageID=oneConentDic[@"ID"];
                    nextPanoramaRoadLink.DstImageID=nextLinkDic[@"PID"];
                    double nextAngle= 360 -([MRXCPanoramaTool getYawByStartLon:[oneConentDic[@"X"] doubleValue] StartLat:[oneConentDic[@"Y"] doubleValue] EndLon:[nextLinkDic[@"X"] doubleValue] EndLat:[nextLinkDic[@"Y"] doubleValue]] -[northDir doubleValue]-[moveDir doubleValue]-[heading doubleValue]);
                    nextPanoramaRoadLink.Angle=@(nextAngle);
                    [panoramaDataList addObject:nextPanoramaRoadLink];
                }
              }
            }

            NSArray* linksArray=oneConentDic[@"Links"];
            for (int i=0; i<linksArray.count; i++) {
                NSDictionary* oneLinkDic=linksArray[i];
                MRXCPanoramaRoadLink* panoramaRoadLink=[[MRXCPanoramaRoadLink alloc] init];
                panoramaRoadLink.SrcImageID=oneConentDic[@"ID"];
                panoramaRoadLink.DstImageID=oneLinkDic[@"PID"];
                double angle=360 -([MRXCPanoramaTool getYawByStartLon:[oneConentDic[@"X"] doubleValue] StartLat:[oneConentDic[@"Y"] doubleValue] EndLon:[oneLinkDic[@"X"] doubleValue] EndLat:[oneLinkDic[@"Y"] doubleValue]] -[northDir doubleValue]-[moveDir doubleValue]-[heading doubleValue]);
                panoramaRoadLink.Angle=@(angle);
                [panoramaDataList addObject:panoramaRoadLink];
            }
        }
    }
    return panoramaDataList;
}
-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumPhere;
}

@end
