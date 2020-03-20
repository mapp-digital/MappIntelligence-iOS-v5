//
//  DefaultTracker.h
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 10/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#ifndef DefaultTracker_h
#define DefaultTracker_h
#import <UIKit/UIKit.h>

#endif /* DefaultTracker_h */

@interface DefaultTracker : NSObject
@property BOOL isReady;
+ (nullable instancetype)sharedInstance;
- (NSString *_Nullable)generateEverId;
- (void)track:(UIViewController *_Nonnull)controller;
- (void)trackWith:(NSString *_Nonnull)name;
+ (NSUserDefaults *_Nonnull)sharedDefaults;
- (void)initHibernate;
- (void)updateFirstSessionWith: (UIApplicationState) state;
@end
