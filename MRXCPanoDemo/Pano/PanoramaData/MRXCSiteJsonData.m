//
//  MRXCSiteJsonData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCSiteJsonData.h"

@implementation MRXCSiteJsonData
@synthesize imgurl=_imgurl;
@synthesize guid=_guid;
@synthesize name=_name;
@synthesize age=_age;
@synthesize type=_type;
@synthesize location=_location;
@synthesize x=_x;
@synthesize y=_y;

+(NSArray *)parserSiteJsonData:(NSObject *)object{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if([object isKindOfClass:[NSDictionary class]]){
        MRXCSiteJsonData *data = [MRXCSiteJsonData createSiteJsonData:(NSDictionary *)object];
        [array addObject:data];
    }
    if([object isKindOfClass:[NSArray class]]){
        for(NSDictionary *dict in (NSArray *)object){
            MRXCSiteJsonData *data = [MRXCSiteJsonData createSiteJsonData:dict];
            [array addObject:data];
        }
    }
    return array;
}
+(MRXCSiteJsonData *)createSiteJsonData:(NSDictionary *)dictionary{
    MRXCSiteJsonData *data = [[MRXCSiteJsonData alloc]init];
    data.imgurl=[dictionary objectForKey:@"imgurl"];
    data.guid=[dictionary objectForKey:@"guid"];
    data.name=[dictionary objectForKey:@"name"];
    data.age=[dictionary objectForKey:@"age"];
    data.type=[dictionary objectForKey:@"type"];
    data.location=[dictionary objectForKey:@"location"];
    data.x=[dictionary objectForKey:@"x"];
    data.y=[dictionary objectForKey:@"y"];
    return data;
}
@end
