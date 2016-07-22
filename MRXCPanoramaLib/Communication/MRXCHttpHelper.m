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

#import "JSONKit.h"


@implementation MRXCHttpHelper
DEF_SINGLETON(MRXCHttpHelper)
-(void)GetResponseDataByUrl:(NSString*)urlStr Callback:(MRXCCompletionBlock)callback;
{
    //通过url创建网络请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
     WEAK_SELF;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        STRONG_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                callback(nil,connectionError);
            }else
            {
                NSError* error;
                if (data==nil) {
                    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"data is nil"                                                                      forKey:NSLocalizedDescriptionKey];
                    error=[NSError errorWithDomain:CustomErrorDomain code:-1 userInfo:userInfo];
                }
                callback(data,error);
            }
        });
    }];
}
-(void)PostResponseDataByUrl:(NSString*)urlStr Params:(NSDictionary*)params Callback:(MRXCCompletionBlock)callback
{
    NSLog(@"%@",urlStr);
    //通过url创建网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //设置请求为post的
    [request setHTTPMethod:@"POST"];
    //将消息的键值对，转换为JSON字符串
    NSString* postStr=[params JSONString];
    NSLog(@"%@",postStr);
    //将JSON字符串，转换为二进制
    NSData* postData= [postStr dataUsingEncoding:NSUTF8StringEncoding];
    //二进制设置为HTTP的消息体
    [request setHTTPBody:postData];
    //设置HTTP的格式为JSON的
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //发送请求
     WEAK_SELF;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        STRONG_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                callback(nil,connectionError);
            }else
            {
                callback(data,nil);
            }
        });
    }];
}
-(void)PostResponseDataByUrl2:(NSString*)urlStr Params:(NSString*)params Callback:(MRXCCompletionBlock)callback
{
    //通过url创建网络请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
    NSString* postStr=@"";
    postStr = [postStr stringByAppendingString:params];
    
    NSData* postData= [postStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:postData];
     WEAK_SELF;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        STRONG_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                callback(nil,connectionError);
            }else
            {
                callback(data,nil);
            }
        });
    }];
}
@end