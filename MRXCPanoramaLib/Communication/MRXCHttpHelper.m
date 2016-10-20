//
//  MRXCHttpHelper.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MRXCHttpHelper.h"
#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

#import "JSONKit.h"

@interface MRXCHttpHelper()
@property(nonatomic,strong) AFHTTPSessionManager* httpSessionManager;
@end

@implementation MRXCHttpHelper
DEF_SINGLETON(MRXCHttpHelper)
-(AFHTTPSessionManager*)httpSessionManager
{
    if (!_httpSessionManager) {
        _httpSessionManager=[AFHTTPSessionManager manager];
    }
    return _httpSessionManager;
}
-(void)GetResponseDataByUrl:(NSString*)urlStr Callback:(MRXCCompletionBlock)callback;
{
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    self.httpSessionManager.responseSerializer=[AFHTTPResponseSerializer new];;
    NSURLSessionDataTask *dataTask = [self.httpSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            callback(nil,error);
        } else {
            callback(responseObject,nil);
        }
    }];
    [dataTask resume];
}
@end
