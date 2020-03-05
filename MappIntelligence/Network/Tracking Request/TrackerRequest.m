//
//  TrackerRequest.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "TrackerRequest.h"
#import "TrackingEvent.h"
#import "Properties.h"

@interface TrackerRequest()

@property TrackingEvent* event;
@property Properties* properties;

-(void) initWithEvent: (TrackingEvent*) event andWithProperties: (Properties*) properties;

@end

@implementation TrackerRequest

- (void)initWithEvent:(TrackingEvent *)event andWithProperties:(Properties *)properties {
    self.event = event;
    self.properties = properties;
}
@end
