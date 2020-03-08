//
//  RequestTrackerBuilder.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/6/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "RequestTrackerBuilder.h"

@implementation RequestTrackerBuilder

- (instancetype)initWithConfoguration:(Configuration *)conf {
    self.configuration = conf;
    return self;
}

- (TrackerRequest *)createRequestWith:(TrackingEvent *)event andWith:(Properties *)properties {
    return [[TrackerRequest alloc] initWithEvent:event andWithProperties:properties];
}

@end
