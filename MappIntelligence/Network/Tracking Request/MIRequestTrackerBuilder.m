//
//  MIRequestTrackerBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIRequestTrackerBuilder.h"

@implementation MIRequestTrackerBuilder

- (instancetype)initWithConfoguration:(MIConfiguration *)conf {
  self.configuration = conf;
  return self;
}

- (TrackerRequest *)createRequestWith:(TrackingEvent *)event
                              andWith:(MIProperties *)properties {
  return
      [[TrackerRequest alloc] initWithEvent:event andWithProperties:properties];
}

@end
