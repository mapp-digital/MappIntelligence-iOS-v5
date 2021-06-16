//
//  Product.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIProduct.h"

#define key_name @"name"
#define key_cost @"cost"
#define key_quantity @"quantity"
#define key_product_variant @"productVariant"
#define key_product_advertise_id @"productAdvertiseID"
#define key_product_sold_out @"productSoldOut"
#define key_categories @"categories"
#define key_ecommerceParameters @"ecommerceParameters"

@implementation MIProduct

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _name = dictionary[key_name];
        _cost = dictionary[key_cost];
        _quantity = dictionary[key_quantity];
        _productVariant = dictionary[key_product_variant];
        _productAdvertiseID = dictionary[key_product_advertise_id];
        _productSoldOut = dictionary[key_product_sold_out];
        _categories = dictionary[key_categories];
        _ecommerceParameters = dictionary[key_ecommerceParameters];
    }
    return self;

}

- (NSString *)name {
    return (_name == NULL) ? @"" : _name;
}


/*
 if (_productAdvertiseID) {
     [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb675" value:[_productAdvertiseID stringValue] ]];
 }
 if (_productSoldOut) {
     [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb760" value:[_productSoldOut stringValue]]];
 }
 if (_productVariant) {
     [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb767" value:_productVariant]];
 }
 */
@end
