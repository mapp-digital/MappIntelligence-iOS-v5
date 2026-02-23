//
//  Product.h
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MIProduct : NSObject

@property (nonatomic, nullable) NSString* name;
@property (nonatomic, nullable) NSNumber* cost;
@property (nonatomic, nullable) NSNumber* quantity;
@property (nullable) NSNumber* productAdvertiseID;
@property (nullable) NSNumber* productSoldOut;
@property (nullable) NSString* productVariant;

@property (nullable) NSDictionary<NSNumber* ,NSString*>* categories;
@property (nullable) NSDictionary<NSNumber* ,NSString*>* ecommerceParameters;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end

NS_ASSUME_NONNULL_END
