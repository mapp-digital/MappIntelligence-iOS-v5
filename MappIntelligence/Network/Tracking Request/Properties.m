//
//  Properties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "Properties.h"

@implementation Properties

- (instancetype)initWithEverID:(NSString *)eid andSamplingRate:(NSInteger)rate withTimeZone:(NSTimeZone *)zone withTimestamp:(NSDate *)stamp withUserAgent:(NSString *)agent {
    self.everId = eid;
    self.samplingRate = rate;
    self.timeZone = zone;
    self.timestamp = stamp;
    self.userAgent = agent;
    return self;
}

@end
