//
//  MIFromSubmitEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 1.2.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackingEvent.h"
#import "MIUsageStatistics.h"
#import "MIFormParameters.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIFormSubmitEvent : MITrackingEvent

@property (nonatomic, nullable) MIFormParameters *formParameters;

@end

NS_ASSUME_NONNULL_END
