//
//  ZHDPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/3/27.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "ZHDPanoSource.h"

@implementation ZHDPanoSource
- (NSURLRequest *)achievePanoByLon:(float)lon Lat:(float)lat Tolerance:(float)tolerance
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoByLonLat?lon=%f&lat=%f&tolerance=%f", self.panoramaUrl,lon,lat,tolerance];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
- (NSURLRequest *)achievePanoByID:(NSString *)panoID
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoByID?imageID=%@", self.panoramaUrl, (panoID == nil) ? @"" : panoID ];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
- (NSURLRequest *)achievePanoThumbnailByID:(NSString *)panoID
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoTile?TileID=%@%%2D1%%2D0%%2D0%%2D0%%2D0", self.panoramaUrl, [MRXCBuildURL achieveURLCodeString:panoID]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:baseURL]];
    [request setHTTPMethod:@"GET"];
    return request ;
}
-(NSURLRequest *)achievePanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col
{
    NSString *baseURL=[NSString stringWithFormat:@"%@/GetPanoTile?TileID=%@%%2D1%%2D%d%%2D%d%%2D%d%%2D%d", self.panoramaUrl, [MRXCBuildURL achieveURLCodeString:panoID], face, level, row, col];
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
    MRXCPanoramaData* panoramaData = [MRXCPanoramaData createPanoramaIDData:[response  JSONValue]];
    return panoramaData;
}
-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
@end
