//
//  MRXCPanoramaConnection.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRXCPanoramaRequestProtocol.h"
#import "MRXCPanoramaRequestData.h"

@interface MRXCPanoramaConnection : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSURLRequest *_request;
    NSHTTPURLResponse *_response;
    NSURLConnection *_connection;
    NSMutableData *_resultData;
    SEL _selector;
    SEL _progressSelector;
    MRXCPanoramaRequestData *_panoramaData;
    NSMutableDictionary *_dictionary;
}
@property(strong, nonatomic)NSURLRequest *request;
@property(strong, nonatomic)NSHTTPURLResponse *response;
@property(strong, nonatomic)NSMutableData *resultData;
@property(strong, nonatomic)MRXCPanoramaRequestData *panoramaData;
@property(strong, nonatomic)NSMutableDictionary *dictionary;
@property(weak, nonatomic)id target;
@property(weak, nonatomic)id<MRXCPanoramaRequestProtocol> delegate;
@property(assign, nonatomic)SEL selector;
@property(assign, nonatomic)SEL progressSelector;

- (id)initWithURLRequest:(NSURLRequest*)request target:(id)target selector:(SEL)selector delegate:(id<MRXCPanoramaRequestProtocol>)delegate;
- (id)initWithURLRequest:(NSURLRequest*)request target:(id)target selector:(SEL)selector progressSelector:(SEL)progressSelector delegate:(id<MRXCPanoramaRequestProtocol>)delegate dictionary:(NSMutableDictionary *)dictionary;
- (id)initWithURLRequest:(NSURLRequest*)request target:(id)target selector:(SEL)selector delegate:(id<MRXCPanoramaRequestProtocol>)delegate panoramaRequestData:(MRXCPanoramaRequestData *)panoramaData;
- (void)cancelRequest;
@end
