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
@property (nonatomic, nonnull) NSNumber* autoTracking;
@property (nonatomic, nonnull) NSNumber* backgroundSendout;
@property (nonatomic, nonnull) NSNumber* userMatching;
@property (nonatomic, nonnull) NSNumber* webview;
@property (nonatomic, nonnull) NSNumber* setEverId;
@property (nonatomic, nonnull) NSNumber* appVersionInEveryRequest;
@property (nonatomic, nonnull) NSNumber* crashTracking;
@property (nonatomic, nonnull) NSNumber* batchSupport;

- (void)printUserStatistics;
/// returns value which will be sent to server
- (NSString*)getUserStatisticsValue;
- (void)reset;
@end

NS_ASSUME_NONNULL_END
