//
//  TrackingEvent.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/5/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MITrackingEvent : NSObject

@property NSString *pageName;
@property NSDictionary *variables;
@property NSObject *viewControllerType;

@property NSDictionary<NSString *,NSString *> *trackingParams;

@end

NS_ASSUME_NONNULL_END
