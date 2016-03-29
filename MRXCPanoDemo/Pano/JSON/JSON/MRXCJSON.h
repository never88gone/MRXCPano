
#import <Foundation/Foundation.h>
#import "MRXCJsonParser.h"
#import "MRXCJsonWriter.h"

/**
 @brief Facade for DBJsonWriter/DBJsonParser.

 Requests are forwarded to instances of DBJsonWriter and DBJsonParser.
 */
@interface MRXCJSON : MRXCJsonBase <MRXCJsonParser, MRXCJsonWriter> {

@private    
    MRXCJsonParser *jsonParser;
    MRXCJsonWriter *jsonWriter;
}


/// Return the fragment represented by the given string
- (id)fragmentWithString:(NSString*)jsonrep
                   error:(NSError**)error;

/// Return the object represented by the given string
- (id)objectWithString:(NSString*)jsonrep
                 error:(NSError**)error;

/// Parse the string and return the represented object (or scalar)
- (id)objectWithString:(id)value
           allowScalar:(BOOL)x
    			 error:(NSError**)error;


/// Return JSON representation of an array  or dictionary
- (NSString*)stringWithObject:(id)value
                        error:(NSError**)error;

/// Return JSON representation of any legal JSON value
- (NSString*)stringWithFragment:(id)value
                          error:(NSError**)error;

/// Return JSON representation (or fragment) for the given object
- (NSString*)stringWithObject:(id)value
                  allowScalar:(BOOL)x
    					error:(NSError**)error;


@end
