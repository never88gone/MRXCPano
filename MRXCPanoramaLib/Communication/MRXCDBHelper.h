//
//  MRXCDBHelper.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "FuncDefine.h"
@interface MRXCDBHelper : NSObject
AS_SINGLETON(MRXCDBHelper);
-(void)initWithPath:(NSString*)dataPath;
-(void)executeQuery:(NSString*)sqlStr  Callback:(MRXCCompletionBlock)callback;
@end
