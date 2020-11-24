//
//  EcommerceProperties.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, Status) {
    addedToBasket,
    purchased,
    viewed,
    list
};

@interface EcommerceProperties : NSObject

@property (nullable) NSArray<Product*>* products;
@property Status status;
@property (nullable) NSString* currencyCode;
@property (nullable) NSString* orderNumber;
@property (nullable) NSString* orderValue;
//new values
@property (nullable) NSString* returningOrNewCustomer;
@property (nullable) NSNumber* returnValue;
@property (nullable) NSNumber* cancellationValue;
@property (nullable) NSNumber* cuponValue;
@property (nullable) NSNumber* productAdvertiseID;
@property (nullable) NSNumber* productSoldOut;
@property (nullable) NSString* paymentMethod;
@property (nullable) NSString* shippingServiceProvider;
@property (nullable) NSString* shippingSpeed;
@property (nullable) NSNumber* shippingCost;
@property (nullable) NSNumber* markUp;
@property (nullable) NSString* productVariant;
@property (nullable) NSNumber* appInstalled;

@property (nullable) NSDictionary<NSNumber* ,NSArray<NSString*>*>* customProperties;

- (instancetype)initWithCustomProperties: (NSDictionary<NSNumber* ,NSArray<NSString*>*>* _Nullable) properties;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
