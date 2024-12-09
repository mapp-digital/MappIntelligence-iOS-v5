//
//  Properties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIProperties.h"
#import "MIDefaultTracker.h"

@implementation MIProperties

- (instancetype)initWithEverID:(NSString *)eid
               andSamplingRate:(NSInteger)rate
                  withTimeZone:(NSTimeZone *)zone
                 withTimestamp:(NSDate *)stamp
                 withUserAgent:(NSString *)agent {
  self.everId = eid;
  self.samplingRate = rate;
  self.timeZone = zone;
  self.timestamp = stamp;
  self.userAgent = agent;
  return self;
}

@end
