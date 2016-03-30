//
//  TXPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "TXPanoSource.h"
#import "GDataXMLNode.h"
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
- (NSURLRequest *)achievePanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance
{
//    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid?lon=%f&lat=%f&tolerance=%f", self.panoramaUrl,lon,lat,tolerance];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:baseURL]];
//    [request setHTTPMethod:@"GET"];
//    return request ;
    return nil;
}
- (NSURLRequest *)achievePanoByID:(NSString *)panoID
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@", self.panoramaUrl,@"sv",panoID ];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
- (NSURLRequest *)achievePanoThumbnailByID:(NSString *)panoID
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=0&y=0&level=0&size=0", self.imageURlStr,@"thumb", [MRXCBuildURL achieveURLCodeString:panoID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
-(NSURLRequest *)achievePanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=%d&y=%d&level=%d", self.imageURlStr,@"tile", [MRXCBuildURL achieveURLCodeString:panoID],row,col,level];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
- (NSURLRequest *)achieveAdjacentPano:(NSString *)panoID
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetAdjacentPano?ImageID=%@", self.panoramaUrl, [MRXCBuildURL achieveURLCodeString:panoID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}

-(MRXCPanoramaData*)getPanoramaDataByResponse:(NSString*)response
{
    MRXCPanoramaData* panoramaData=[[MRXCPanoramaData alloc] init];
    //对象初始化
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:response options:0 error:nil];
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
        panoramaData.x=x;
        panoramaData.y=y;
        panoramaData.imageID=imageID;
        
    }
    //TODO:这个解析有点麻烦，需要花点时间调整
    return panoramaData;
}

-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumPhere;
}
@end
