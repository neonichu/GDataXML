#import <GHUnitIOS/GHUnit.h>

#import "GDataXMLNode.h"

@interface ZdfMediathekHtmlTest : GHTestCase { }
@end

@implementation ZdfMediathekHtmlTest

- (void)testParse {
    NSData *xmlData = [[NSData alloc] initWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"zdf-mediathek" ofType:@"html"]];
    GHAssertNotNil(xmlData, @"XML data could not be load.");
    
    xmlData = 
    
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    if (doc == nil) { 
        GHFail(@"Parser error: %@", error);
    }
    
    NSLog(@"%@", doc.rootElement);
    
    [doc release];
    [xmlData release];
}

@end