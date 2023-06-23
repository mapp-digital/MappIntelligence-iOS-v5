//
//  MIUsageStatistics.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 21.6.23..
//  Copyright © 2023 Mapp Digital US, LLC. All rights reserved.
//

#import "MIUsageStatistics.h"
#include <math.h>

@implementation MIUsageStatistics

- (instancetype)init {
    _activityAutoTracking = [NSNumber  numberWithDouble:0];
    _fragmentsAutoTracking = [NSNumber  numberWithDouble:0];
    _autoTracking = [NSNumber  numberWithDouble:pow(2, 7)];
    _backgroundSendout = [NSNumber  numberWithDouble:pow(2, 6)];
    _userMatching = [NSNumber  numberWithDouble:pow(2, 5)];
    _webview = [NSNumber  numberWithDouble:0];
    _setEverId = [NSNumber numberWithDouble:pow(2, 3)];
    _appVersionInEveryRequest = [NSNumber  numberWithDouble:pow(2, 2)];
    _crashTracking = [NSNumber  numberWithDouble:pow(2, 1)];
    _batchSupport = [NSNumber  numberWithDouble:pow(2, 0)];
    return self;
}

- (void)setAutoTracking:(NSNumber *)autoTracking {
    if([autoTracking isEqualToNumber:[NSNumber numberWithInt:0]])
        _autoTracking = [NSNumber numberWithInt:0];
    else
        _autoTracking = [NSNumber  numberWithDouble:pow(2, 7)];
}

- (void)setBackgroundSendout:(NSNumber *)backgroundSendout {
    if([backgroundSendout isEqualToNumber:[NSNumber numberWithInt:0]])
        _backgroundSendout = [NSNumber numberWithInt:0];
    else
        _backgroundSendout = [NSNumber  numberWithDouble:pow(2, 6)];
}

- (void)setUserMatching:(NSNumber *)userMatching {
    if([userMatching isEqualToNumber:[NSNumber numberWithInt:0]])
        _userMatching = [NSNumber numberWithInt:0];
    else
        _userMatching = [NSNumber  numberWithDouble:pow(2, 5)];
}

- (void)setSetEverId:(NSNumber *)setEverId {
    if([setEverId isEqualToNumber:[NSNumber numberWithInt:0]])
        _setEverId = [NSNumber numberWithInt:0];
    else
        _setEverId = [NSNumber  numberWithDouble:pow(2, 3)];
}

- (void)setAppVersionInEveryRequest:(NSNumber *)appVersionInEveryRequest {
    if([appVersionInEveryRequest isEqualToNumber:[NSNumber numberWithInt:0]])
        _appVersionInEveryRequest = [NSNumber numberWithInt:0];
    else
        _appVersionInEveryRequest = [NSNumber  numberWithDouble:pow(2, 2)];
}

- (void)setCrashTracking:(NSNumber *)crashTracking {
    if([crashTracking isEqualToNumber:[NSNumber numberWithInt:0]])
        _crashTracking = [NSNumber numberWithInt:0];
    else
        _crashTracking = [NSNumber  numberWithDouble:pow(2, 1)];
}

- (void)setBatchSupport:(NSNumber *)batchSupport {
    if([batchSupport isEqualToNumber:[NSNumber numberWithInt:0]])
        _batchSupport = [NSNumber numberWithInt:0];
    else
        _batchSupport = [NSNumber  numberWithDouble:pow(2, 0)];
}

- (void)printUserStatistics {
    NSLog(@"===================================================");
    NSLog(@"===================Usage Statistics================");
    NSLog(@"Activity Auto Tracking: %i\nFragments Auto Tracking: %i\nAuto Tracking: %i\nBackground Sendout: %i\nUser Matching: %i\n Webview: %i\nSet EverId: %i\nApp Version in every Request: %i\nCrash Tracking: %i Batch Support: %i\n", [_activityAutoTracking intValue], [_fragmentsAutoTracking intValue], [_autoTracking intValue], [_backgroundSendout intValue], [_userMatching intValue], [_webview intValue], [_setEverId intValue], [_appVersionInEveryRequest intValue], [_crashTracking intValue], [_batchSupport intValue] );
    NSLog(@"===================================================");
}

- (NSString*)getUserStatisticsValue {
    return [NSString stringWithFormat:@"%i",([_activityAutoTracking intValue] + [_fragmentsAutoTracking intValue] + [_autoTracking intValue] + [_backgroundSendout intValue] + [_userMatching intValue] + [_webview intValue] + [_setEverId intValue] + [_appVersionInEveryRequest intValue] + [_crashTracking intValue] + [_batchSupport intValue])];
}

- (void)reset {
    _batchSupport = [NSNumber numberWithInt:0];
    _userMatching = [NSNumber numberWithInt:0];
}

@end
