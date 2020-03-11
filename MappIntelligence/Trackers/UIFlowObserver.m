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
#endif

@end

@implementation UIFlowObserver

- (instancetype)initWith:(DefaultTracker *)tracker {
    self = [super init];
    _tracker = tracker;
    return self;
}

-(BOOL)setup {
#if !TARGET_OS_WATCHOS
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
//    applicationWillResignActiveObserver = [notificationCenter addObserverForName:  object:<#(nullable id)#> queue:<#(nullable NSOperationQueue *)#> usingBlock:<#^(NSNotification * _Nonnull note)block#>];
#else
#endif
  return YES;
}

@end
