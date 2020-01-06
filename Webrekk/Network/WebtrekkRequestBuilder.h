//
//  WebtrekkRequestBuilder.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebtrekkRequest.h"

@interface WebtrekkRequestBuilder : NSObject

/*!
 * Singleton instance
 */
+ (instancetype)shared;

/*!
 * Class initialization.
 */
+ (instancetype)builder;

/**
 Add key-values to a request.
 @brief Method will add key-values to a request.
 @param keyedValues
 NSDictionary containing key-value objects.
 @param type
 WebtrekkRequestKeyType enum value.
 */
- (void)addRequestKeyedValues:(NSDictionary *)keyedValues forRequestType:(WebtrekkRequestKeyType)type;

/**
 Create an NSData JSON formated object with the added key-values.
 @brief Method will create an NSData JSON formated object with the added key-values.
 @attention Calling this method clear any key-value storage previously added.
 @return NSData object, formated in a JSON format, or nil if no key-values were added prior to calling this method.
 */
- (NSData *)buildRequestAsJsonData;

- (NSData *)buildRequestForPushOpenAsJsonData;

@end

