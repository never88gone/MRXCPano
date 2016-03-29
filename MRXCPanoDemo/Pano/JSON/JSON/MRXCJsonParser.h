
#import <Foundation/Foundation.h>
#import "MRXCJsonBase.h"

/**
  @brief Options for the parser class.
 
 This exists so the MRXCJSON facade can implement the options in the parser without having to re-declare them.
 */
@protocol MRXCJsonParser

/**
 @brief Return the object represented by the given string.
 
 Returns the object represented by the passed-in string or nil on error. The returned object can be
 a string, number, boolean, null, array or dictionary.
 
 @param repr the json string to parse
 */
- (id)objectWithString:(NSString *)repr;

@end


/**
 @brief The JSON parser class.
 
 JSON is mapped to Objective-C types in the following way:
 
 @li Null -> NSNull
 @li String -> NSMutableString
 @li Array -> NSMutableArray
 @li Object -> NSMutableDictionary
 @li Boolean -> NSNumber (initialised with -initWithBool:)
 @li Number -> NSDecimalNumber
 
 Since Objective-C doesn't have a dedicated class for boolean values, these turns into NSNumber
 instances. These are initialised with the -initWithBool: method, and 
 round-trip back to JSON properly. (They won't silently suddenly become 0 or 1; they'll be
 represented as 'true' and 'false' again.)
 
 JSON numbers turn into NSDecimalNumber instances,
 as we can thus avoid any loss of precision. (JSON allows ridiculously large numbers.)
 
 */
@interface MRXCJsonParser : MRXCJsonBase <MRXCJsonParser> {
    
@private
    const char *c;
}

@end

// don't use - exists for backwards compatibility with 2.1.x only. Will be removed in 2.3.
@interface MRXCJsonParser (Private)
- (id)fragmentWithString:(id)repr;
@end


