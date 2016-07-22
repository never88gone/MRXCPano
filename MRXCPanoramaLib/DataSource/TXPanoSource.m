//
//  TXPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "TXPanoSource.h"
#import "GDataXMLNode.h"
#import "MRXCPanoramaTool.h"
#import "MRXCHttpHelper.h"
#import "MRXCPanoramaRoadLink.h"

@implementation TXPanoSource
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.panoramaUrl=@"http://sv.map.qq.com";
        self.imageURlStr=@"http://sv1.map.qq.com";
    }
    return self;
}



- (void)getPanoStationByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    WEAK_SELF;
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid?lon=%f&lat=%f&tolerance=%f", self.panoramaUrl,@"sv",lon,lat,tolerance];
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
    WEAK_SELF;
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@", self.panoramaUrl,@"sv",panoID ];
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
    WEAK_SELF;
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=0&y=0&level=0&size=0", self.imageURlStr,@"thumb", [MRXCPanoramaTool achieveURLCodeString:panoID]];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
    
}
- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    WEAK_SELF;
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=%d&y=%d&level=%d", self.imageURlStr,@"tile", [MRXCPanoramaTool achieveURLCodeString:panoID],row,col,level];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
}
- (void)getLinkStationS:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    WEAK_SELF;
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
    MRXCPanoramaStation* panoramaData=[[MRXCPanoramaStation alloc] init];
    //    对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:response error:nil];
    //获取根节点
    GDataXMLElement *rootElement = [doc rootElement];
    //获取其他节点
    NSArray *basices = [rootElement elementsForName:@"basic"];
    if (basices.count>0) {
        GDataXMLElement *baseElement=basices[0];
        //        NSString *b=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *cameraNo=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *gatherTime=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        NSString *imageID=[[baseElement attributeForName:@"svid"]  stringValue];
        //        NSString *l=[[[baseElement elementsForName:@"x"] objectAtIndex:0] stringValue];
        //        NSString *pitch=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *roadName=[[[baseElement elementsForName:@"sno"] objectAtIndex:0] stringValue];
        //        NSString *roll=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *routeID=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *segmentID=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        //        NSString *segmentIndex=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        NSString *x=[[baseElement attributeForName:@"x"] stringValue];
        NSString *y=[[baseElement attributeForName:@"y"] stringValue];
        //        NSString *yaw=[[[baseElement elementsForName:@"dir"] objectAtIndex:0] stringValue];
        //        NSString *z=[[[baseElement elementsForName:@"append_addr"] objectAtIndex:0] stringValue];
        panoramaData.X=x;
        panoramaData.Y=y;
        panoramaData.ImageID=imageID;
        
    }
    //TODO:这个解析有点麻烦，需要花点时间调整
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
    return PanoramaEnumPhere;
}



@end
