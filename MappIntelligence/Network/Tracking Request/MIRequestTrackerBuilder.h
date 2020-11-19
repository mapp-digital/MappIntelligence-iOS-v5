//
//  MIRequestTrackerBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIConfiguration.h"
#import "TrackingEvent.h"
#import "MIProperties.h"
#import "TrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIRequestTrackerBuilder : NSObject

@property MIConfiguration *configuration;

- (instancetype)initWithConfoguration:(MIConfiguration *)conf;
- (TrackerRequest *)createRequestWith:(TrackingEvent *)event
                              andWith:(MIProperties *)properties;
@end

NS_ASSUME_NONNULL_END
