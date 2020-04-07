//
//  TrackerRequest.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 2/12/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TrackingEvent.h"
#import "Properties.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackerRequest : NSObject

@property TrackingEvent *event;
@property Properties *properties;

- (instancetype)initWithEvent:(TrackingEvent *)event
            andWithProperties:(Properties *)properties;
- (void)sendRequestWith:(NSURL *)url
        andCompletition:(void (^)(NSError *error))handler;

@end

NS_ASSUME_NONNULL_END
