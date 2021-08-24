//
//  MIUIFlowObserver.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/11/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIUIFlowObserver.h"
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#else
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#endif

#define doesAppEnterInBackground @"enteredInBackground";

@interface MIUIFlowObserver ()

@property MIDefaultTracker *tracker;
#if !TARGET_OS_WATCH
@property UIApplication *application;
#endif
@property NSObject *applicationDidBecomeActiveObserver;
@property NSObject *applicationWillEnterForegroundObserver;
@property NSObject *applicationWillResignActiveObserver;
@property NSObject *applicationWillTerminataObserver;
@property NSUserDefaults *sharedDefaults;
@property NSString* TIME_WHEN_APP_ENTERS_TO_BACKGROUND;
#if !TARGET_OS_WATCH
@property UIBackgroundTaskIdentifier backgroundIdentifier;
#endif

@end

@implementation MIUIFlowObserver

- (instancetype)initWith:(MIDefaultTracker *)tracker {
    self = [super init];
    _tracker = tracker;
    //to force new session only for TV, bacause notficataion for willenterforeground do not work on TVOS
#if TARGET_OS_TV
    [_tracker updateFirstSessionWith:[[UIApplication sharedApplication]
                                      applicationState]];
#endif
    self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND = @"Background_Time";
    _sharedDefaults = [NSUserDefaults standardUserDefaults];
    
    return self;
}

- (void)fireRequest {
    
}

- (BOOL)setup {
  NSNotificationCenter *notificationCenter =
      [NSNotificationCenter defaultCenter];
#if !TARGET_OS_WATCH
    //Posted when the app becomes active.
    _applicationDidBecomeActiveObserver = [notificationCenter addObserverForName: UIApplicationDidBecomeActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self didBecomeActive];
    }];
    //Posted shortly before an app leaves the background state on its way to becoming the active app.
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:UIApplicationWillEnterForegroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterForeground];
    }];
    //Posted when the app is no longer active and loses focus.
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:UIApplicationWillResignActiveNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
    //terminate, not called always
    [notificationCenter addObserverForName:UIApplicationWillTerminateNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        //[self willResignActive];
    }];
    
    [notificationCenter addObserverForName:UIApplicationDidEnterBackgroundNotification object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willEnterBckground];
    }];
#else
    _applicationWillEnterForegroundObserver = [notificationCenter addObserverForName:@"UIApplicationWillEnterForegroundNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        
        [self willEnterForeground];
    }];
    _applicationDidBecomeActiveObserver = [notificationCenter addObserverForName: @"UIApplicationDidBecomeActiveNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self didBecomeActive];
    }];
    _applicationWillTerminataObserver = [notificationCenter addObserverForName:@"UIApplicationWillTerminateNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willTerminate];
    }];
    _applicationWillResignActiveObserver = [notificationCenter addObserverForName:@"UIApplicationWillResignActiveNotification" object:NULL queue:NULL usingBlock:^(NSNotification * _Nonnull note) {
        [self willResignActive];
    }];
#endif
  return YES;
}

-(void)didBecomeActive {
    
}

-(void)willEnterForeground {
#if !TARGET_OS_WATCH
  [_tracker updateFirstSessionWith:[[UIApplication sharedApplication]
                                       applicationState]];
    self.backgroundIdentifier = (unsigned long)[[NSUserDefaults standardUserDefaults] integerForKey:@"backgroundIdentifier"];
    if (self.backgroundIdentifier == UIBackgroundTaskInvalid) {
        [self->_tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"the requests are not deleted!!!");
            }
        }];
    }
    [[UIApplication sharedApplication] endBackgroundTask: self.backgroundIdentifier];
    self.backgroundIdentifier = UIBackgroundTaskInvalid;
    
    //remove all request if app is enough time in background to send all requests
    NSDate* dateWhenAppIsBackFromBackground =  (NSDate*) [NSUserDefaults.standardUserDefaults objectForKey:self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND];
    if (dateWhenAppIsBackFromBackground) {
        NSDateComponents *components;
        NSInteger seconds;

        components = [[NSCalendar currentCalendar] components: NSCalendarUnitSecond
                fromDate: dateWhenAppIsBackFromBackground toDate: [NSDate date] options: 0];
        seconds = [components second];
        if (seconds > 30) {
            [self->_tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"the requests are not deleted!!!");
                }
            }];
        }
    }
    
#else
  [_tracker updateFirstSessionWith:WKApplicationStateActive];
#endif
}

-(void)willResignActive {
#if TARGET_OS_WATCH
    [_sharedDefaults setBool:YES forKey:@"enteredInBackground"];
    [_sharedDefaults synchronize];
#endif
	  [_tracker initHibernate];
}

-(void)willTerminate {
    
}

-(void)willEnterBckground {
    NSLog(@"enter background and send all requests");
    [NSUserDefaults.standardUserDefaults setValue:[NSDate date] forKey:self.TIME_WHEN_APP_ENTERS_TO_BACKGROUND];
    [[NSUserDefaults standardUserDefaults] synchronize];
#if !TARGET_OS_WATCH
    self.backgroundIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithName:@"com.mapp.background" expirationHandler:^{
        [self->_tracker sendBatchForRequestInBackground: YES withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"the requests are not sent!!!");
            }
            
            [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
            self.backgroundIdentifier = UIBackgroundTaskInvalid;
            [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundIdentifier];
        self.backgroundIdentifier = UIBackgroundTaskInvalid;
        [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [[NSUserDefaults standardUserDefaults] setInteger:self.backgroundIdentifier forKey:@"backgroundIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
#endif
}

@end

