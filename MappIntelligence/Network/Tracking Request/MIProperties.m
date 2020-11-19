//
//  Properties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIProperties.h"

static NSString *const appVersonKey = @"kAppVersion";
static NSString *const buildVersonKey = @"kBuildVersion";

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

- (NSString *) getAppVersion {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleShortVersionString"];
}

- (NSString *) getBuildVersion {
    return NSBundle.mainBundle.infoDictionary[@"CFBundleVersion"];
}

- (BOOL) isAppUpdated {
    NSString *previousVersion = [[NSUserDefaults standardUserDefaults] stringForKey:appVersonKey];
    if (!previousVersion) {
        [[NSUserDefaults standardUserDefaults] setObject:self.appVersion forKey:appVersonKey];
        return NO;
    }
    if ([previousVersion isEqual:self.appVersion]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.appVersion forKey:appVersonKey];
        return YES;
    }
}

@end
