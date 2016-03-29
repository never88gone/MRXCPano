//
//  MRXCPanoramaConnection.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCPanoramaConnection.h"

@implementation MRXCPanoramaConnection
@synthesize request=_request;
@synthesize response=_response;
@synthesize resultData=_resultData;
@synthesize panoramaData=_panoramaData;
@synthesize dictionary=_dictionary;
@synthesize target=_target;
@synthesize delegate=_delegate;
@synthesize selector=_selector;
@synthesize progressSelector=_progressSelector;

- (id)initWithURLRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector delegate:(id<MRXCPanoramaRequestProtocol>)delegate{
    self = [super init];
    if(self == nil){
        return nil;
    }
    _resultData = [[NSMutableData alloc]init];
    self.request = request;
    self.target = target;
    self.selector = selector;
    self.delegate = delegate;
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    return self;
}
- (id)initWithURLRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector progressSelector:(SEL)progressSelector delegate:(id<MRXCPanoramaRequestProtocol>)delegate dictionary:(NSMutableDictionary *)dictionary{
    self = [super init];
    if(self == nil){
        return nil;
    }
    _resultData = [[NSMutableData alloc]init];
    self.request = request;
    self.target = target;
    self.selector = selector;
    self.progressSelector = progressSelector;
    self.delegate = delegate;
    self.dictionary = dictionary;
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    return self;
}
- (id)initWithURLRequest:(NSURLRequest *)request target:(id)target selector:(SEL)selector delegate:(id<MRXCPanoramaRequestProtocol>)delegate panoramaRequestData:(MRXCPanoramaRequestData *)panoramaData{
    self = [super init];
    if(self == nil){
        return nil;
    }
    _resultData = [[NSMutableData alloc]init];
    self.request = request;
    self.target = target;
    self.selector = selector;
    self.delegate = delegate;
    self.panoramaData = panoramaData;
    _connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    return self;
}
- (void)cancelRequest{
    [_connection cancel];
}
#pragma mark -
#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [_target performSelector:_selector withObject:self];
    [_connection cancel];
}

#pragma mark -
#pragma mark - NSURLConnectionData delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    self.response = (NSHTTPURLResponse *)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    if([_response statusCode] == 200){
        [_resultData appendData:data];
        if(self.progressSelector != nil){
            long long contentLength = [[[_response allHeaderFields] objectForKey:@"Content-Length"] longLongValue];
            double downloadProgress = (double)_resultData.length/(double)contentLength;
            [self.dictionary setObject:[NSNumber numberWithDouble:downloadProgress] forKey:@"DownLoadProgress"];
            [self.dictionary setObject:[NSNumber numberWithLongLong:contentLength] forKey:@"Content-Length"];
            [_target performSelector:_progressSelector withObject:self];
        }
    }
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite{
    
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    [_target performSelector:_selector withObject:self];
}
@end
