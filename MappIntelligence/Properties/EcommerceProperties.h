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
@property (nullable) Status* status;
@property (nullable) NSString* currencyCode;
@property (nullable) NSString* orderNumber;
@property (nullable) NSString* orderValue;
@property (nullable) NSDictionary<NSNumber* ,NSArray<NSString*>*>* customProperties;

- (instancetype)initWithCustomProperties: (NSDictionary<NSNumber* ,NSArray<NSString*>*>* _Nullable) properties;
- (NSMutableArray<NSURLQueryItem*>*)asQueryItems;

@end

NS_ASSUME_NONNULL_END
