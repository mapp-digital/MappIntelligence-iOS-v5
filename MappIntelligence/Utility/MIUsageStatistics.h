//
//  MIUsageStatistics.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 21.6.23..
//  Copyright © 2023 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIUsageStatistics : NSObject

@property (nonnull) NSNumber* activityAutoTracking;
@property (nonnull) NSNumber* fragmentsAutoTracking;
@property (nonnull) NSNumber* autoTracking;
@property (nonnull) NSNumber* backgroundSendout;
@property (nonnull) NSNumber* userMatching;
@property (nonnull) NSNumber* webview;
@property (nonnull) NSNumber* setEverId;
@property (nonnull) NSNumber* appVersionInEveryRequest;
@property (nonnull) NSNumber* crashTracking;
@property (nonnull) NSNumber* batchSupport;

- (void)printUserStatistics;
- (NSString*)getUserStatisticsValue;
@end

NS_ASSUME_NONNULL_END
