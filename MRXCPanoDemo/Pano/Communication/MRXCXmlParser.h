//
//  MRXCXmlParser.h
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MRXCXmlParser : NSObject<NSXMLParserDelegate>{
    NSMutableDictionary *_dictionary;
    NSMutableDictionary *_subdict;
    NSString *_elementName;
}
@property(strong, nonatomic)NSMutableDictionary *dictionary;
@property(strong, nonatomic)NSMutableDictionary *subdict;
@property(strong, nonatomic)NSString *elementName;
@property(weak, nonatomic)id target;
@property(assign, nonatomic)SEL selector;

+ (void)xmlParser:(NSData *)xmldata target:(id)target selector:(SEL)selector;
@end
