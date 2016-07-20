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
- (void)achievePanoByLonLatResponse:(NSString *)responseStr success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoByIDResponse:(NSString *)responseStr success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoThumbnailByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achievePanoTileByIDResponse:(NSData *)response success:(BOOL)success info:(NSDictionary *)dict;
- (void)achieveAdjacentPanoResponse:(NSArray *)response success:(BOOL)success info:(NSDictionary *)dict;
@end
