//
//  HtmlTidy.m
//
//  Created by Boris Buegling on 17.05.11.
//  Heavily based on the CTidy class from TouchXML.
//

#import "HtmlTidy.h"

#import "buffio.h"

@implementation HtmlTidy

- (NSData *)tidyData:(NSData*)data inputFormat:(HtmlTidyFormat)inputFormat outputFormat:(HtmlTidyFormat)outputFormat
         diagnostics:(NSString**)diagnostics error:(NSError**)error {
    TidyDoc doc = tidyCreate();
    
    int result = 0;
    
    if (inputFormat == HtmlTidyFormat_XML) {
        result = tidyOptSetBool(doc, TidyXmlTags, YES);
        NSAssert(result >= 0, @"tidyOptSetBool() should return 0");
    }
    
    TidyOptionId outputId;
    switch (outputFormat) {
        case HtmlTidyFormat_HTML4:
            outputId = TidyHtmlOut;
            break;
        case HtmlTidyFormat_XHTML:
            outputId = TidyXmlOut;
            break;
        default:
            outputId = TidyXmlOut;
            break;
    }
    
    result = tidyOptSetBool(doc, outputId, YES);
    NSAssert(result >= 0, @"tidyOptSetBool() should return 0");
    
    result = tidyOptSetBool(doc, TidyForceOutput, YES);
    NSAssert(result >= 0, @"tidyOptSetBool() should return 0");
    
    result = tidySetOutCharEncoding(doc, "utf8");
    NSAssert(result >= 0, @"tidySetOutCharEncoding() should return 0");
    
    TidyBuffer errBuf;
    tidyBufInit(&errBuf);
    result = tidySetErrorBuffer(doc, &errBuf);
    NSAssert(result >= 0, @"tidySetErrorBuffer() should return 0");
    
    // Create an input buffer and copy input to it (TODO uses 2X memory == bad!)
    TidyBuffer inpBuf;
    tidyBufAlloc(&inpBuf, [data length]);
    memcpy(inpBuf.bp, [data bytes], [data length]);
    inpBuf.size = [data length];
    
    result = tidyParseBuffer(doc, &inpBuf);
    if (result < 0 && error) {
        NSDictionary *theUserInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSString stringWithUTF8String:(char *)errBuf.bp], 
                                     NSLocalizedDescriptionKey, nil];
        *error = [NSError errorWithDomain:@"vu0.org.GDataXML" code:result userInfo:theUserInfo];
        return nil;
    }	
    tidyBufFree(&inpBuf);
    
    result = tidyCleanAndRepair(doc);
    if (result < 0) {
        // TODO: set error
        return nil;
    }
    
    TidyBuffer outBuf;
    tidyBufInit(&outBuf);
    result = tidySaveBuffer(doc, &outBuf);
    if (result < 0) {
        // TODO: set error
        return nil;
    }
    NSAssert(outBuf.bp != NULL, @"The buffer should not be null.");
    
    data = [NSData dataWithBytes:outBuf.bp length:outBuf.size];
    tidyBufFree(&outBuf);
    
    if (diagnostics && errBuf.bp) {
        NSData *errorData = [NSData dataWithBytes:errBuf.bp length:errBuf.size];
        *diagnostics = [[[NSString alloc] initWithData:errorData encoding:NSUTF8StringEncoding] autorelease];
    }
    tidyBufFree(&errBuf);
    
    tidyRelease(doc);
    
    return data;
}

@end
