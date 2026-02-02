//
//  TrackerRequest.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MITrackingEvent.h"
#import "MIProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface MITrackerRequest : NSObject <NSURLSessionDataDelegate>

/**
 MappIntelligence instance
 @brief Method to get a singleton instance of MITrackerReques
 @code
 let MITrackerRequestSingleton = MITrackerRequest.shared()
 @endcode
 @return MappIntelligence an Instance Type of MITrackerRequest.
 */
+ (nullable instancetype)shared;

@property MITrackingEvent *event;
@property MIProperties *properties;

- (instancetype)initWithEvent:(MITrackingEvent *)event
            andWithProperties:(MIProperties *)properties;
- (void)sendRequestWith:(NSURL *)url
        andCompletition:(void (^)(NSError *error))handler;
- (void)sendRequestWith:(NSURL *)url andBody:(NSString*)body andCompletition:(void (^)(NSError *error))handler;
- (void)sendBackgroundRequestWith:(NSURL *)url andBody:(NSString*)body;

@end

NS_ASSUME_NONNULL_END
