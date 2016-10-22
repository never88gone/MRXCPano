//
//  LocalMNPanoSource.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/10/22.
//  Copyright © 2016年 never88gone. All rights reserved.
//
#define  _PANORAMA_THUMBNAIL_SIZE_  256.0
#import "LocalMNPanoSource.h"
#import "UIImage+Sacle.h"
@implementation LocalMNPanoSource

- (void)getPanoStationByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    MRXCPanoramaStation* panoramaStation=[[MRXCPanoramaStation alloc]init];
    panoramaStation.ImageID=panoID;
    if (completionBlock) {
        completionBlock(panoramaStation,nil);
    }
    
}
- (void)getPanoThumbnailByID:(NSString *)panoID CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString *baseURL=[NSString stringWithFormat:@"http://pano7.qncdn.720static.com/resource/prod/d7ei7382fr3/50323czf91s/773539/imgs/preview.jpg"];
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        UIImage* image=[UIImage imageWithData:returnData];
        NSMutableArray* imageArray=[NSMutableArray array];
        UIImage *  leftRectImage = [MRXCPanoramaTool imageInRect:image x:0 y:0 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];

        
        UIImage *fontRectImage = [MRXCPanoramaTool imageInRect:image x:0 y:_PANORAMA_THUMBNAIL_SIZE_ width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        
        
        UIImage *rightRectImage = [MRXCPanoramaTool imageInRect:image x:0 y:_PANORAMA_THUMBNAIL_SIZE_*2 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        
        
        UIImage *backImage = [MRXCPanoramaTool imageInRect:image x:0 y:_PANORAMA_THUMBNAIL_SIZE_*3 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
       
        
        UIImage *  topRectImage = [MRXCPanoramaTool imageInRect:image x:0 y:_PANORAMA_THUMBNAIL_SIZE_*4 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        topRectImage=[topRectImage imageRotateRotation:UIImageOrientationDown];
        
        UIImage *  bottomRectImage =  [MRXCPanoramaTool imageInRect:image x:0 y:_PANORAMA_THUMBNAIL_SIZE_*5 width:_PANORAMA_THUMBNAIL_SIZE_ height:_PANORAMA_THUMBNAIL_SIZE_];
        
        [imageArray addObject:rightRectImage];
        [imageArray addObject:leftRectImage];
        [imageArray addObject:backImage  ];
        [imageArray addObject:fontRectImage];
        [imageArray addObject:topRectImage];
        [imageArray addObject:bottomRectImage];
        
        if (completionBlock) {
            completionBlock(imageArray,anError);
        }
    }];
}

- (void)getPanoTileByID:(NSString *)panoID level:(int)level face:(int)face row:(int)row col:(int)col CompletionBlock:(MRXCCompletionBlock)completionBlock
{
    NSString* faceStr=nil;
    switch (face) {
        case 1:
        {
            faceStr=@"f";
        }
            break;
        case 2:
        {
            faceStr=@"r";
        }
            break;
        case 3:
        {
            faceStr=@"b";
        }
            break;
        case 4:
        {
            faceStr=@"l";
        }
            break;
        case 5:
        {
            faceStr=@"u";
        }
            break;
        case 6:
        {
            faceStr=@"d";
        }
            break;
        default:
            break;
    }
    NSString *baseURL=[NSString stringWithFormat:@"http://pano7.qncdn.720static.com/resource/prod/d7ei7382fr3/50323czf91s/773539/imgs/%@/%@/%d/%@_%@_%d_%d.jpg",faceStr,@"l2",row+1,@"l2",faceStr, row+1, col+1];
    if (face==5) {
        baseURL=[NSString stringWithFormat:@"http://pano7.qncdn.720static.com/resource/prod/d7ei7382fr3/50323czf91s/773539/imgs/%@/%@/%d/%@_%@_%d_%d.jpg",faceStr,@"l2",row+1,@"l2",faceStr, row, col];
    }
    [[MRXCHttpHelper sharedInstance] GetResponseDataByUrl:baseURL Callback:^(id aResponseObject, NSError *anError) {
        NSData* returnData=(NSData*)aResponseObject;
        if (completionBlock) {
            completionBlock(returnData,anError);
        }
    }];
}

-(PanoramaCubeOrPhere)getPanoramaType
{
    return PanoramaEnumCube;
}
- (int)cubeFaceIndex:(int)tileIndex{
    switch (tileIndex) {
        case 1:
            return 3;
            break;
        case 2:
            return 0;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 1;
            break;
        case 5:
            return 4;
            break;
        case 6:
            return 5;
            break;
        default:
            break;
    }
    return tileIndex;
}
@end
