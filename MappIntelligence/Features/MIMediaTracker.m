//
//  MIMediaTracker.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaTracker.h"

@interface MIMediaTracker ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSDate *> *lastTrackedTimeByKey;
@end

@implementation MIMediaTracker

+ (nullable instancetype)sharedInstance {

  static MIMediaTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIMediaTracker alloc] init];
    shared.lastTrackedTimeByKey = [[NSMutableDictionary alloc] init];
  });
  return shared;
}

-(BOOL) shouldTrack: (MIMediaEvent *) event {

    NSDate *now = [[NSDate alloc] init];
    NSTimeInterval allowedInterval = event.mediaParameters.duration == 0 ? 60 : 3;
    NSString *mediaName = event.mediaParameters.name ?: @"";
    NSString *action = event.mediaParameters.action ?: @"";
    NSString *key = [NSString stringWithFormat:@"%@|%@", mediaName, action];

    NSDate *lastTrackedTime = self.lastTrackedTimeByKey[key];
    if (lastTrackedTime) {
        NSTimeInterval elapsed = [now timeIntervalSinceDate:lastTrackedTime];
        if (elapsed < allowedInterval) {
            return NO;
        }
    }

    self.lastTrackedTimeByKey[key] = now;
    return YES;
}

@end
