//
//  MIConfiguration.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 3/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIConfiguration : NSObject

/// url for remote tracking server
@property NSURL *serverUrl;

/// Id which identify customer
@property NSString *MappIntelligenceId;

@property NSTimeInterval requestInterval;

@property NSInteger requestPerQueue;

@end

NS_ASSUME_NONNULL_END
