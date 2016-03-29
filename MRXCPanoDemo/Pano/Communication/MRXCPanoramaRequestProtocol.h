//
//  MRXCPanoramaRequestProtocol.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MRXCPanoramaRequestProtocol <NSObject>
@optional
- (void)achievePanoByLonLatResponse:(NSDictionary *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoByIDResponse:(NSDictionary *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoThumbnailByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoTileByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achieveAdjacentPanoResponse:(NSArray *)response success:(BOOL)success info:(NSDictionary *)dict;
@end
