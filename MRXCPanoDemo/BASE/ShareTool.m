//
//  ShareTool.m
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/11/1.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "ShareTool.h"
#import <UMSocialCore/UMSocialCore.h>

@implementation ShareTool
DEF_SINGLETON(ShareTool)
- (void)shareToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString*)title WithContent:(NSString*)content WithImage:(UIImage*)image WithUrl:(NSString*)url
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //设置文本
    messageObject.text = title;
    UMShareWebpageObject* webpageObject=[UMShareWebpageObject shareObjectWithTitle:title descr:content thumImage:image];
    webpageObject.webpageUrl=url;
    messageObject.shareObject=webpageObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}
@end
