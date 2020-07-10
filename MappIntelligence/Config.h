//
//  Config.h
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceLogger.h"

@protocol Config

// MappIntelligence default configuration parameters:

@property NSArray *const trackIDs;
@property NSString *const trackDomain;
@property (nonatomic, setter = setRequestsInterval:) NSTimeInterval requestsInterval;
@property MappIntelligenceLogLevelDescription logLevel;
@property BOOL autoTracking;
@property NSInteger const requestPerQueue;
@property BOOL batchSupport;
@property BOOL viewControllerAutoTracking;
@property BOOL optOut;

@end
