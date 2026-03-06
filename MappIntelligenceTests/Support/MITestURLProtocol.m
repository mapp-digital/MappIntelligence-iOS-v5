#import "MITestURLProtocol.h"

static NSInteger MITestURLProtocolStatusCode = 200;
static NSData *MITestURLProtocolData = nil;
static NSError *MITestURLProtocolError = nil;

@implementation MITestURLProtocol

+ (void)stubWithStatusCode:(NSInteger)statusCode data:(NSData *)data error:(NSError *)error {
    MITestURLProtocolStatusCode = statusCode;
    MITestURLProtocolData = data;
    MITestURLProtocolError = error;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

- (void)startLoading {
    if (MITestURLProtocolError) {
        [self.client URLProtocol:self didFailWithError:MITestURLProtocolError];
        return;
    }

    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL
                                                              statusCode:MITestURLProtocolStatusCode
                                                             HTTPVersion:@"HTTP/1.1"
                                                            headerFields:@{ @"Content-Type": @"text/plain" }];
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];

    if (MITestURLProtocolData) {
        [self.client URLProtocol:self didLoadData:MITestURLProtocolData];
    }

    [self.client URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
}

@end
