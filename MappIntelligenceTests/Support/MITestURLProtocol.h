#import <Foundation/Foundation.h>

@interface MITestURLProtocol : NSURLProtocol
+ (void)stubWithStatusCode:(NSInteger)statusCode data:(NSData *)data error:(NSError *)error;
@end
