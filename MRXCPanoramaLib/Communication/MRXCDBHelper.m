//
//  MRXCDBHelper.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/21.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MRXCDBHelper.h"
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

- (void)performInMainThreadBlock:(void(^)())aInMainBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        aInMainBlock();
        
    });
}

- (void)performInThreadBlock:(void(^)())aInThreadBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        aInThreadBlock();
        
    });
}

@end
