//
//  EcommerceProperties.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIProduct.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MIStatus) {
    noneStatus = 0,
    addedToBasket = 1,
    purchased = 2,
    viewed = 3,
    deletedFromBasket = 4,
    addedToWishlist = 5,
    deletedFromWishlist = 6,
    checkout = 7
};

@interface MIEcommerceParameters : NSObject

@property (nullable) NSArray<MIProduct*>* products;
@property (nonatomic) MIStatus status;
@property (nullable) NSString* currency;
@property (nullable) NSString* orderID;
@property (nullable) NSNumber* orderValue;
//new values
@property (nullable) NSString* returningOrNewCustomer;
@property (nullable) NSNumber* returnValue;
@property (nullable) NSNumber* cancellationValue;
@property (nullable) NSNumber* couponValue;
@property (nullable) NSString* paymentMethod;
@property (nullable) NSString* shippingServiceProvider;
@property (nullable) NSString* shippingSpeed;
@property (nullable) NSNumber* shippingCost;
@property (nullable) NSNumber* markUp;
@property (nullable) NSString* orderStatus;

@property (nullable) NSDictionary<NSNumber* ,NSString*>* customParameters;

- (instancetype)initWithCustomParameters: (NSDictionary<NSNumber* ,NSString*>* _Nullable) parameters;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
