//
//  TrackerRequest.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingEvent.h"
#import "MIProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackerRequest : NSObject

@property TrackingEvent *event;
@property MIProperties *properties;

- (instancetype)initWithEvent:(TrackingEvent *)event
            andWithProperties:(MIProperties *)properties;
- (void)sendRequestWith:(NSURL *)url
        andCompletition:(void (^)(NSError *error))handler;
- (void)sendRequestWith:(NSURL *)url andBody:(NSString*)body andCompletition:(void (^)(NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
