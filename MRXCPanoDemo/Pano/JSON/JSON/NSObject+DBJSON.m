
#import "NSObject+DBJSON.h"
#import "MRXCJsonWriter.h"




@implementation NSObject (NSObject_DBJSON)

- (NSString *)JSONFragment {
    MRXCJsonWriter *jsonWriter = [MRXCJsonWriter new];
    NSString *json = [jsonWriter stringWithFragment:self];    
    if (!json)
        NSLog(@"-JSONFragment failed. Error trace is: %@", [jsonWriter errorTrace]);
    [jsonWriter release];
    return json;
}

- (NSString *)JSONRepresentation {
    MRXCJsonWriter *jsonWriter = [MRXCJsonWriter new];
    NSString *json = [jsonWriter stringWithObject:self];
    if (!json)
        NSLog(@"-JSONRepresentation failed. Error trace is: %@", [jsonWriter errorTrace]);
    [jsonWriter release];
    return json;
}

@end


