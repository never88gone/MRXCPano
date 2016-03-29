//
//  MRXCSiteContentJsonData.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCSiteContentJsonData.h"

@implementation MRXCSiteContentJsonData
@synthesize x=_x;
@synthesize mediadescribe=_mediadescribe;
@synthesize imgurl=_imgurl;
@synthesize guid=_guid;
@synthesize name=_name;
@synthesize age=_age;
@synthesize y=_y;
@synthesize abstruct=_abstruct;
@synthesize type=_type;
@synthesize location=_location;

+(NSArray *)parserSiteContentJsonData:(NSObject *)object{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if([object isKindOfClass:[NSDictionary class]]){
        MRXCSiteContentJsonData *data = [MRXCSiteContentJsonData createSiteContentJsonData:(NSDictionary *)object];
        [array addObject:data];
    }
    if([object isKindOfClass:[NSArray class]]){
        for(NSDictionary *dict in (NSArray *)object){
            MRXCSiteContentJsonData *data = [MRXCSiteContentJsonData createSiteContentJsonData:dict];
            [array addObject:data];
        }
    }
    return array;
}
+(MRXCSiteContentJsonData *)createSiteContentJsonData:(NSDictionary *)dictionary{
    MRXCSiteContentJsonData *data = [[MRXCSiteContentJsonData alloc]init];
    data.x=[dictionary objectForKey:@"x"];
    data.mediadescribe=[dictionary objectForKey:@"mediadescribe"];
    data.imgurl=[dictionary objectForKey:@"imgurl"];
    data.guid=[dictionary objectForKey:@"guid"];
    data.name=[dictionary objectForKey:@"name"];
    data.age=[dictionary objectForKey:@"age"];
    data.y=[dictionary objectForKey:@"y"];
    data.abstruct=[dictionary objectForKey:@"abstruct"];
    data.type=[dictionary objectForKey:@"type"];
    data.location=[dictionary objectForKey:@"location"];
    return data;
}
@end
