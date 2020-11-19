//
//  MIUIFlowObserver.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/11/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIDefaultTracker.h"

NS_ASSUME_NONNULL_BEGIN

@interface MIUIFlowObserver : NSObject

- (instancetype)initWith:(MIDefaultTracker *)tracker;
- (BOOL)setup;

@end

NS_ASSUME_NONNULL_END
