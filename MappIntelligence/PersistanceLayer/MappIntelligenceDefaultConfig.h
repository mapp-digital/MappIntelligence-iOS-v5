//
//  MappIntelligenceDefaultConfig.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 17/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
#import "Config.h"
#import "DefaultTracker.h"

extern NSTimeInterval const requestIntervalDefault;
extern BOOL const optOutDefault;
extern BOOL const batchSupportDefault;
extern NSInteger const requestPerQueueDefault;
extern NSInteger const batchSupportSizeDefault;

@interface MappIntelligenceDefaultConfig : NSObject <Config, NSCoding>

- (void)logConfig;
- (void) reset;
- (BOOL) isConfiguredForTracking;
@end
