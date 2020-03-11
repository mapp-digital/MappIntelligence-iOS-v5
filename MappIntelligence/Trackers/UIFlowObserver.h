//
//  UIFlowObserver.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/11/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTracker.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIFlowObserver : NSObject

- (instancetype)initWith:(DefaultTracker *)tracker;
- (BOOL)setup;

@end

NS_ASSUME_NONNULL_END
