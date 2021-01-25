//
//  MIMediaTracker.m
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 08/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import "MIMediaTracker.h"


@interface MIMediaTracker ()
@property (nonatomic, strong) NSDate *lastTrackedTime;
@property (nonatomic, strong) NSDate *lastTrackedTimeLiveStream;
@property MIMediaEvent *lastTrackedEvent;
@property NSString *lastAction;
@end

@implementation MIMediaTracker

+ (nullable instancetype)sharedInstance {

  static MIMediaTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[MIMediaTracker alloc] init];
  });
  return shared;
}

-(BOOL) shouldTrack: (MIMediaEvent *) event {
    //invalid cases
    if (event.mediaParameters.position.doubleValue >= event.mediaParameters.duration.doubleValue) {
        return NO;
    }

    NSDate *now = [[NSDate alloc] init];
    //check if media tracked is live stream
    if (event.mediaParameters.duration == 0) {
        if(_lastTrackedTimeLiveStream) {
            NSTimeInterval allowedInterval = 60;
            NSTimeInterval elapsed = [now timeIntervalSinceDate: _lastTrackedTimeLiveStream];
            if (elapsed < allowedInterval && [_lastAction isEqualToString:event.mediaParameters.action]) {
                return NO;
            }
        }
        _lastAction = event.mediaParameters.action;
        _lastTrackedTimeLiveStream = now;
    } else {
        if(_lastTrackedTime) {
            NSTimeInterval allowedInterval = 3;
            NSTimeInterval elapsed = [now timeIntervalSinceDate: _lastTrackedTime];
            if (elapsed < allowedInterval && [_lastAction isEqualToString:event.mediaParameters.action]) {
                return NO;
            }
        }
        _lastAction = event.mediaParameters.action;
        _lastTrackedTime = now;
    }
    return YES;
}

@end
