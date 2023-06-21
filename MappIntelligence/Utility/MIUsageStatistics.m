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
    _setEverId = [NSNumber  numberWithDouble:pow(2, 3)];
    _appVersionInEveryRequest = [NSNumber  numberWithDouble:pow(2, 2)];
    _crashTracking = [NSNumber  numberWithDouble:pow(2, 1)];
    _batchSupport = [NSNumber  numberWithDouble:pow(2, 0)];
    return self;
}

- (void)printUserStatistics {
    NSLog(@"===================================================");
    NSLog(@"===================Usage Statistics================");
    NSLog(@"Activity Auto Tracking: %i\nFragments Auto Tracking: %i\nAuto Tracking: %i\nBackground Sendout: %i\nUser Matching: %i\n Webview: %i\nSet EverId: %i\nApp Version in every Request: %i\nCrash Tracking: %iBatch Support\n", [_activityAutoTracking intValue], [_fragmentsAutoTracking intValue], [_autoTracking intValue], [_backgroundSendout intValue], [_userMatching intValue], [_webview intValue], [_setEverId intValue], [_appVersionInEveryRequest intValue], [_crashTracking intValue], [_batchSupport intValue] );
    NSLog(@"===================================================");
}

- (NSString*)getUserStatisticsValue {
    return [NSString stringWithFormat:@"%i",([_activityAutoTracking intValue] + [_fragmentsAutoTracking intValue] + [_autoTracking intValue] + [_backgroundSendout intValue] + [_userMatching intValue] + [_webview intValue] + [_setEverId intValue] + [_appVersionInEveryRequest intValue] + [_crashTracking intValue] + [_batchSupport intValue])];
}

@end
