//
//  MRXCHttpHelper.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FuncDefine.h"

@interface MRXCHttpHelper : NSObject
AS_SINGLETON(MRXCHttpHelper);
-(void)GetResponseDataByUrl:(NSString*)urlStr Callback:(MRXCCompletionBlock)callback;
@end
