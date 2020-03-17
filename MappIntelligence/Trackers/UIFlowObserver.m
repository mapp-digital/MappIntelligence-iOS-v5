//
//  UIFlowObserver.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/11/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "UIFlowObserver.h"
#if TARGET_OS_WATCHOS
#else
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#endif

@interface UIFlowObserver ()

@property DefaultTracker *tracker;
#if !TARGET_OS_WATCHOS
@property UIApplication *application;
@property NSObject *applicationDidBecomeActiveObserver;
@property NSObject *applicationWillEnterForegroundObserver;
@property NSObject *applicationWillResignActiveObserver;
@property NSUserDefaults *sharedDefaults;
#endif

@end

@implementation UIFlowObserver

- (instancetype)initWith:(DefaultTracker *)tracker {
    self = [super init];
    _tracker = tracker;
    _sharedDefaults = [NSUserDefaults standardUserDefaults];
    return self;
}

-(BOOL)setup {
#if !TARGET_OS_WATCHOS
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName: UIApplicationDidBecomeActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self didBecomeActive];
    }];
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:UIApplicationWillEnterForegroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterForeground];
    }];
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
#else
#endif
  return YES;
}

-(void)didBecomeActive {
    
}

-(void)willEnterForeground {
    [_tracker updateFirstSession];
}

-(void)willResignActive {
    [_tracker initHibernate];
}

@end

