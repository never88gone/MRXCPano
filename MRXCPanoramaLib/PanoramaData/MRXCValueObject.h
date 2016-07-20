//
//  MRXCValueObject.h
//  MRXCPanoDemo
//
//  Created by never88gone on 16/7/20.
//  Copyright © 2016年 never88gone. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MRXCValueObject : JSONModel
/**
 *  通过字典创建VO
 *
 *  @param aDict 字典
 *
 *  @return VO
 */
+ (instancetype)voWithDict:(NSDictionary *)aDict;
@end
