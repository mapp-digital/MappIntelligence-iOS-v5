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

#endif /* DefaultTracker_h */

@interface MIDefaultTracker : NSObject
@property BOOL isReady;
@property (nonatomic) BOOL anonymousTracking;
@property (nonatomic) BOOL isItFlutter;
@property NSString*_Nullable temporaryID;
@property NSString* _Nonnull version;
@property NSString* _Nonnull platform;
@property (nonatomic) NSArray<NSString*> * _Nullable suppressedParameters;
@property MIUsageStatistics* _Nonnull usageStatistics;

+ (nullable instancetype)sharedInstance;
- (NSString *_Nullable)generateEverId;
- (void)setEverIDFromString: (NSString *_Nonnull)everIDString;
- (NSString*_Nonnull)generateUserAgent;
- (BOOL)isBackgroundSendoutEnabled;
- (BOOL)isUserMatchingEnabled;
- (void)setupVersion: (NSString *_Nonnull) version andPlatform: (NSString *_Nonnull) platform;
- (NSError*_Nullable)track:(UIViewController *_Nonnull)controller;
- (void)updateFirstSessionWith: (UIApplicationState) state;
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
