//
//  RequestTrackerBuilder.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Configuration.h"
#import "TrackingEvent.h"
#import "Properties.h"
#import "TrackerRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestTrackerBuilder : NSObject

@property Configuration *configuration;

- (instancetype)initWithConfoguration:(Configuration *)conf;
- (TrackerRequest *)createRequestWith:(TrackingEvent *)event
                              andWith:(Properties *)properties;
@end

NS_ASSUME_NONNULL_END
