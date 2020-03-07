//
//  TrackerRequest.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "TrackerRequest.h"

@interface TrackerRequest()

@end

@implementation TrackerRequest

- (void)initWithEvent:(TrackingEvent *)event andWithProperties:(Properties *)properties {
    [self setEvent:event];
    [self setProperties:properties];
}

- (void)sendRequest {
    
}
@end
