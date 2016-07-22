//
//  MRXCDBHelper.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MRXCDBHelper.h"
#import "NSObject+Block.h"
@interface MRXCDBHelper();
@property(nonatomic,strong) FMDatabaseQueue *queue;
@end;
@implementation MRXCDBHelper
DEF_SINGLETON(MRXCDBHelper)

-(void)initWithPath:(NSString*)dataPath
{
    self.queue = [FMDatabaseQueue databaseQueueWithPath:dataPath];
}
-(void)executeQuery:(NSString*)sqlStr Callback:(MRXCCompletionBlock)callback;
{
    WEAK_SELF;
    [self.queue inDatabase:^(FMDatabase *db) {
        STRONG_SELF;
        WEAK_SELF;
        [self performInMainThreadBlock:^{
            STRONG_SELF;
            FMResultSet *rs = [db executeQuery:sqlStr];
            if(callback)
            {
                callback(rs,nil);
            }
        }];

    }];  
}



@end
