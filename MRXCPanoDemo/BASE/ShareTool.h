//
//  ShareTool.h
//  MRXCPanoDemo
//
//  Created by never88gone on 2016/11/1.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FuncDefine.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ShareTool : NSObject
AS_SINGLETON(ShareTool);
- (void)shareToPlatformType:(UMSocialPlatformType)platformType withTitle:(NSString*)title WithContent:(NSString*)content WithImage:(UIImage*)image WithUrl:(NSString*)url;
@end
