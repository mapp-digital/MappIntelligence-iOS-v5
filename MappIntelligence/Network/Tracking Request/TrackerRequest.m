//
//  TrackerRequest.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "TrackerRequest.h"
#import "MappIntelligenceLogger.h"

@interface TrackerRequest()

@property MappIntelligenceLogger* loger;
@property NSURLSession* urlSession;

@end

@implementation TrackerRequest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _loger = [[MappIntelligenceLogger alloc] init];
        _urlSession = [[NSURLSession alloc] init];
    }
    return self;
}

- (instancetype)initWithEvent:(TrackingEvent *)event andWithProperties:(Properties *)properties {
    [self setEvent:event];
    [self setProperties:properties];
    return self;
}

- (void)sendRequestWith:(NSURL *)url {
    [_loger logObj: [[NSString alloc] initWithFormat:@"Tracking Request: %@", [url absoluteURL]] forDescription:kMappIntelligenceLogLevelDescriptionInfo];
    
    
    [_urlSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            [self->_loger logObj: [[NSString alloc] initWithFormat:@"Error while executing request: %@", [error description ]] forDescription:kMappIntelligenceLogLevelDescriptionError];
        }
        [self->_loger logObj: [[NSString alloc] initWithFormat:@"Response from tacking server: %@", [error description ]] forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    }];
}
@end
