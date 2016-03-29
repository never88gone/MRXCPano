
#import "NSString+DBJSON.h"
#import "MRXCJsonParser.h"

@implementation NSString (NSString_MRXCJSON)

- (id)JSONFragmentValue
{
    MRXCJsonParser *jsonParser = [MRXCJsonParser new];
    id repr = [jsonParser fragmentWithString:self];    
    if (!repr)
        NSLog(@"-JSONFragmentValue failed. Error trace is: %@", [jsonParser errorTrace]);
    [jsonParser release];
    return repr;
}

- (id)JSONValue
{
    MRXCJsonParser *jsonParser = [MRXCJsonParser new];
    id repr = [jsonParser objectWithString:self];
    if (!repr)
        NSLog(@"-JSONValue failed. Error trace is: %@", [jsonParser errorTrace]);
    [jsonParser release];
    return repr;
}

@end

