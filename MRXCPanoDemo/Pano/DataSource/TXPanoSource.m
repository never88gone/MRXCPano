//
//  TXPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "TXPanoSource.h"

@implementation TXPanoSource
-(instancetype)init
{
    self=[super init];
    if (self) {
        self.panoramaUrl=@"http://sv.map.qq.com/";
        self.imageURlStr=@"http://sv1.map.qq.com/";
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
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=0&y=0&level=0&size=0", self.panoramaUrl,@"thumb", [MRXCBuildURL achieveURLCodeString:panoID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
-(NSURLRequest *)achievePanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/%@?svid=%@&x=%d&y=%d&level=%d", self.panoramaUrl,@"tile", [MRXCBuildURL achieveURLCodeString:panoID],row,col,level];
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

-(MRXCPanoramaIDData*)getPanoramaDataByDic:(NSDictionary*)response
{
    //TODO:这个解析有点麻烦，需要花点时间调整
    return nil;
}

-(PanoramaCubeOrPhere)getParnoramaType
{
    return PanoramaEnumPhere;
}
@end
