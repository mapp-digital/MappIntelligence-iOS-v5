//
//  APXRequestBuilder.h
//  AppoxeeSDK
//
//  Created by Raz Elkayam on 3/2/15.
//  Copyright (c) 2015 Appoxee. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "APXRequest.h"

@interface RequestBuilder : NSObject

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
 APXRequestKeyType enum value.
 */
- (void)addRequestKeyedValues:(NSDictionary *)keyedValues forRequestType:(RequestKeyType)type;

/**
 Create an NSData JSON formated object with the added key-values.
 @brief Method will create an NSData JSON formated object with the added key-values.
 @attention Calling this method clear any key-value storage previously added.
 @return NSData object, formated in a JSON format, or nil if no key-values were added prior to calling this method.
 */
- (NSData *)buildRequestAsJsonData;

@end
