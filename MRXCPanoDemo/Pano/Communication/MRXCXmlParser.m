//
//  MRXCXmlParser.m
//  MRXC
//
//  Created by never88gone on 16-03-27.
//  Copyright (c) 2016年 never88gone. All rights reserved.
//

#import "MRXCXmlParser.h"

@implementation MRXCXmlParser
@synthesize dictionary=_dictionary;
@synthesize subdict=_subdict;
@synthesize elementName=_elementName;
@synthesize selector=_selector;
@synthesize target=_target;

+ (void)xmlParser:(NSData *)xmldata target:(id)target selector:(SEL)selector{
    MRXCXmlParser *xmlParser = [[MRXCXmlParser alloc]init];
    xmlParser.target = target;
    xmlParser.selector = selector;
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:xmldata];
    parser.shouldProcessNamespaces = false;
    parser.shouldReportNamespacePrefixes = false;
    parser.shouldResolveExternalEntities = false;
    parser.delegate = xmlParser;
    [parser parse];
}
- (id)init{
    self = [super init];
    if(self != nil){
        _dictionary = [[NSMutableDictionary alloc]init];
        _subdict = [[NSMutableDictionary alloc]init];
        _elementName = nil;
    }
    return self;
}
#pragma mark -
#pragma mark - NSXMLParserDelegate
// Document handling methods
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}
// sent when the parser begins parsing of the document.
- (void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.target performSelector:self.selector withObject:self];
}
// sent when the parser has completed parsing. If this is encountered, the parse was successful.

// DTD handling methods for various declarations.
- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID{
    
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName{
    
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue{
    
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model{
    
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value{
    
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if([elementName isEqualToString:@"PageBaseConfig"]){
        return;
    }
    if(attributeDict == nil || attributeDict.count == 0){
        if(_subdict.count > 0){
            NSDictionary *dict = [[NSDictionary alloc]initWithDictionary:_subdict];
            [self.dictionary setObject:dict forKey:self.elementName];
            [_subdict removeAllObjects];
        }
        self.elementName = elementName;
        return;
    }
    [_subdict setObject:[attributeDict objectForKey:@"name"] forKey:[attributeDict objectForKey:@"order"]];
}
// sent when the parser finds an element start tag.
// In the case of the cvslog tag, the following is what the delegate receives:
//   elementName == cvslog, namespaceURI == http://xml.apple.com/cvslog, qualifiedName == cvslog
// In the case of the radar tag, the following is what's passed in:
//    elementName == radar, namespaceURI == http://xml.apple.com/radar, qualifiedName == radar:radar
// If namespace processing >isn't< on, the xmlns:radar="http://xml.apple.com/radar" is returned as an attribute pair, the elementName is 'radar:radar' and there is no qualifiedName.

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"PageBaseConfig"]){
        [self.dictionary setObject:_subdict forKey:self.elementName];
    }
}
// sent when an end tag is encountered. The various parameters are supplied as above.

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI{
    
}
// sent when the parser first sees a namespace attribute.
// In the case of the cvslog tag, before the didStartElement:, you'd get one of these with prefix == @"" and namespaceURI == @"http://xml.apple.com/cvslog" (i.e. the default namespace)
// In the case of the radar:radar tag, before the didStartElement: you'd get one of these with prefix == @"radar" and namespaceURI == @"http://xml.apple.com/radar"

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix{
    
}
// sent when the namespace prefix in question goes out of scope.

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    
}
// This returns the string of the characters encountered thus far. You may not necessarily get the longest character run. The parser reserves the right to hand these to the delegate as potentially many calls in a row to -parser:foundCharacters:

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    
}
// The parser reports ignorable whitespace in the same way as characters it's found.

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data{
    
}
// The parser reports a processing instruction to you using this method. In the case above, target == @"xml-stylesheet" and data == @"type='text/css' href='cvslog.css'"

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment{
    
}
// A comment (Text in a <!-- --> block) is reported to the delegate as a single string

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
}
// this reports a CDATA block to the delegate as an NSData.

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID{
    return nil;
}
// this gives the delegate an opportunity to resolve an external entity itself and reply with the resulting data.

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
}
// ...and this reports a fatal error to the delegate. The parser will stop parsing.

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    
}
@end
