//
//  MRXCValueObject.m
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/20.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import "MRXCValueObject.h"

@implementation MRXCValueObject

- (instancetype)init
{
    if (self = [super init]) {
        static dispatch_once_t once;
        dispatch_once(&once, ^{
            [JSONModel setGlobalKeyMapper:[[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"nid"}]];
        });
    }
    return self;
}

/**
 *  重写父类方法，默认可选
 *
 *  @param propertyName 属性名称
 *
 *  @return bool
 */
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

+ (instancetype)voWithDict:(NSDictionary *)aDict
{
    if (![aDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    return [[self alloc] initWithDictionary:aDict error:nil];
}

- (void)dealloc
{
    
}

@end
