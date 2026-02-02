//
//  MIParams.h
//  MappIntelligenceSDK
//
//  Created by Miroljub Stoilkovic on 17/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIParams : NSObject

+(NSString *)internalSearch;
+(NSString *)mediaCode;
+(NSString *)customerId;
+(NSString *)productName;
+(NSString *)productCost;
+(NSString *)productCurrency;
+(NSString *)productQuantity;
+(NSString *)statusOfShoppingCard;
+(NSString *)orderId;
+(NSString *)orderValue;

@end

NS_ASSUME_NONNULL_END
