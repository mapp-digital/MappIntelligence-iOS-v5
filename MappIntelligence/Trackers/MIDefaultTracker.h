//
//  MIDefaultTracker.h
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 10/02/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#ifndef DefaultTracker_h
#define DefaultTracker_h
#import <UIKit/UIKit.h>
#import "MIPageViewEvent.h"
#import "MIFormSubmitEvent.h"
#import "MIActionEvent.h"
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

#endif /* DefaultTracker_h */

@interface MIDefaultTracker : NSObject
@property BOOL isReady;
@property BOOL anonymousTracking;
@property (nonatomic) NSArray<NSString*> * _Nullable suppressedParameters;

+ (nullable instancetype)sharedInstance;
- (NSString *_Nullable)generateEverId;
- (void)setEverIDFromString: (NSString *_Nonnull)everIDString;
- (NSString*_Nonnull)generateUserAgent;
- (BOOL)isBackgroundSendoutEnabled;
#if !TARGET_OS_WATCH
- (NSError*_Nullable)track:(UIViewController *_Nonnull)controller;
- (void)updateFirstSessionWith: (UIApplicationState) state;
#else
- (void)updateFirstSessionWith: (WKApplicationState) state;
#endif
- (NSError*_Nullable)trackWith:(NSString *_Nonnull)name;
- (NSError*_Nullable)trackWithEvent:(MITrackingEvent *_Nonnull)event;
- (NSError *_Nullable)trackWithCustomEvent:(MITrackingEvent *_Nonnull)event;

+ (NSUserDefaults *_Nonnull)sharedDefaults;
- (void)initHibernate;
- (void)reset;
- (void)initializeTracking;
- (void)sendRequestFromDatabaseWithCompletionHandler: (void (^_Nullable)(NSError * _Nullable error))handler;
- (void)sendBatchForRequestInBackground: (BOOL)background withCompletionHandler: (void (^_Nullable)(NSError * _Nullable error))handler;
- (void)removeAllRequestsFromDBWithCompletionHandler: (void (^_Nullable)(NSError * _Nullable error))handler;
- (void)migrateData;
@end
