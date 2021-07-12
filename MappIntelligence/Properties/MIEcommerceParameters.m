//
//  MIEcommerceProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIEcommerceParameters.h"
#import "MappIntelligenceLogger.h"

#define key_products @"products"
#define key_status @"status"
#define key_currency @"currency"
#define key_order_id @"orderID"
#define key_order_value @"orderValue"
#define key_returning_or_new_customer @"returningOrNewCustomer"
#define key_return_value @"returnValue"
#define key_cancellation_value @"cancellationValue"
#define key_coupon_value @"couponValue"
#define key_payment_method @"paymentMethod"
#define key_shipping_service_provider @"shippingServiceProvider"
#define key_shippingSpeed @"shippingSpeed"
#define key_shipping_cost @"shippingCost"
#define key_mark_up @"markUp"
#define key_order_status @"orderStatus"
#define key_custom_parameters @"customParameters"

@interface MIEcommerceParameters()
@property NSNumberFormatter* formatter;
@end

@implementation MIEcommerceParameters

- (instancetype)initWithCustomParameters:(NSDictionary<NSNumber *,NSString *> *)parameters {
    self = [super init];
    if (self) {
        _customParameters = parameters;
        _formatter = [[MappIntelligenceLogger shared] formatter];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        _formatter = [[MappIntelligenceLogger shared] formatter];
        NSArray<NSDictionary*>* products = dictionary[key_products];
        if (products && [products count] > 0) {
            _products = [NSMutableArray new];
            for (NSDictionary* dict in products) {
                _products = [_products arrayByAddingObject:[[MIProduct alloc] initWithDictionary:dict]];
            }
        }
        _status = [self getStatusFrom:(int)dictionary[key_status]];
        _currency = dictionary[key_currency];
        _orderID = dictionary[key_order_id];
        _orderValue = dictionary[key_order_value];
        _returningOrNewCustomer = dictionary[key_returning_or_new_customer];
        _returnValue = dictionary[key_return_value];
        _cancellationValue = dictionary[key_cancellation_value];
        _couponValue = dictionary[key_coupon_value];
        _paymentMethod = dictionary[key_payment_method];
        _shippingServiceProvider = dictionary[key_shipping_service_provider];
        _shippingSpeed = dictionary[key_shippingSpeed];
        _shippingCost = dictionary[key_shipping_cost];
        _markUp = dictionary[key_mark_up];
        _orderStatus = dictionary[key_order_status];
        _customParameters = dictionary[key_custom_parameters];
    }
    return self;
}

- (MIStatus) getStatusFrom:(int) status {
    switch (status) {
        case 0:
            return noneStatus;
            break;
        case 1:
            return addedToBasket;
            break;
        case 2:
            return purchased;
            break;
        case 3:
            return viewed;
            break;
        default:
            return viewed;
    }}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    
    _formatter = [[MappIntelligenceLogger shared] formatter];
    
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    [items addObjectsFromArray:[self getProductsAsQueryItems]];
    
    if (_customParameters) {
        _customParameters = [self filterCustomDict:_customParameters];
        for(NSNumber* key in _customParameters) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: _customParameters[key]]];
        }
    }
    
    if (_currency) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cr" value:_currency]];
    }
    if (_orderID) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"oi" value:_orderID]];
    }
    if (_orderValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ov" value:[_formatter stringFromNumber:_orderValue]]];
    }
    if (_status) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"st" value:[self getStatus]]];
    }
    
    [items addObjectsFromArray:[self getUserPredefinedPropertiesAsQueryItems]];
    
    return items;
}

- (NSString*)getStatus {
    switch ((int)_status) {
        case addedToBasket:
            return @"add";
            break;
        case purchased:
            return @"conf";
            break;
        case viewed:
            return @"view";
            break;
        default:
            return @"view";
    }
}

- (void)setStatus:(MIStatus)status {
    _status = status;
}

- (NSMutableArray<NSURLQueryItem *> *)getUserPredefinedPropertiesAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if (_returningOrNewCustomer) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb560" value:_returningOrNewCustomer]];
    }
    if (_returnValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb561" value:[_formatter stringFromNumber:_returnValue]]];
    }
    if (_cancellationValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb562" value:[_formatter stringFromNumber:_cancellationValue]]];
    }
    if (_couponValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb563" value:[_formatter stringFromNumber:_couponValue]]];
    }
    
    if (_paymentMethod) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb761" value:_paymentMethod]];
    }
    if (_shippingServiceProvider) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb762" value:_shippingServiceProvider]];
    }
    if (_shippingSpeed) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb763" value:_shippingSpeed]];
    }
    if (_shippingCost) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb764" value:[_formatter stringFromNumber:_shippingCost]]];
    }
    if (_markUp) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb765" value:[_formatter stringFromNumber:_markUp]]];
    }
    if (_orderStatus) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb766" value:_orderStatus]];
    }
    return items;
}

- (NSMutableArray<NSURLQueryItem *> *)getProductsAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if(_products) {
        NSMutableArray<NSString*>* productNames = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productCosts = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productQuantities = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productAdvertiseIDs = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productSoldOuts = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productVariants = [[NSMutableArray alloc] init];
        NSMutableArray* categoriesKeys = [[NSMutableArray alloc] init];
        NSMutableArray* ecommerceParametersKeys = [[NSMutableArray alloc] init];
        
        for (MIProduct* product in _products) {
            [productNames addObject: product.name];
            [productCosts addObject: (product.cost ? [_formatter stringFromNumber:product.cost] : @"")];
            [productQuantities addObject: (product.quantity ? [product.quantity stringValue] : @"")];
            [productAdvertiseIDs addObject:product.productAdvertiseID ? [product.productAdvertiseID stringValue] : @""];
            [productSoldOuts addObject:product.productSoldOut ? [product.productSoldOut stringValue] : @""];
            [productVariants addObject:product.productVariant ? product.productVariant : @""];
            [categoriesKeys addObjectsFromArray:product.categories.allKeys];
            [ecommerceParametersKeys addObjectsFromArray:product.ecommerceParameters.allKeys];
        }
        
        categoriesKeys = [[[NSSet setWithArray:categoriesKeys] allObjects] copy];
        ecommerceParametersKeys = [[[NSSet setWithArray:ecommerceParametersKeys] allObjects] copy];
        
        NSMutableArray<NSString*>* tempCategories = [[NSMutableArray alloc] init];
        for (NSNumber* key in categoriesKeys) {
            [tempCategories removeAllObjects];
            for (MIProduct* product in _products) {
                NSString* tmpObject = [[[product categories] allKeys] containsObject:key] ? product.categories[key] : @"";
                [tempCategories addObject: tmpObject];
            }
            NSString* keyValue = [key isKindOfClass:[NSString class]] ? (NSString*)key : (NSString*)[key stringValue];
            [items addObject:[[NSURLQueryItem alloc] initWithName:[@"ca" stringByAppendingString:keyValue] value:[tempCategories componentsJoinedByString:@";"]]];
        }
        
        [tempCategories removeAllObjects];
        for (NSNumber* key in ecommerceParametersKeys) {
            [tempCategories removeAllObjects];
            for (MIProduct* product in _products) {
                NSString* tmpObject = [[[product ecommerceParameters] allKeys] containsObject:key] ? product.ecommerceParameters[key] : @"";
                [tempCategories addObject: tmpObject];
            }
            NSString* keyValue = [key isKindOfClass:[NSString class]] ? (NSString*)key : (NSString*)[key stringValue];
            [items addObject:[[NSURLQueryItem alloc] initWithName:[@"cb" stringByAppendingString:keyValue] value:[tempCategories componentsJoinedByString:@";"]]];
        }
        
        if (![self isEmpty:productAdvertiseIDs])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb675" value:[productAdvertiseIDs componentsJoinedByString:@";"]]];
        if (![self isEmpty:productSoldOuts])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb760" value:[productSoldOuts componentsJoinedByString:@";"]]];
        if (![self isEmpty:productVariants])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb767" value:[productVariants componentsJoinedByString:@";"]]];
        if (![self isEmpty: productNames])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"ba" value:[productNames componentsJoinedByString:@";"]]];
        if (![self isEmpty:productCosts])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"co" value:[productCosts componentsJoinedByString:@";"]]];
        if ((_status != viewed) && ![self isEmpty:productQuantities])
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"qn" value:[productQuantities componentsJoinedByString:@";"]]];
    }
    
    return items;
}


- (NSDictionary<NSNumber* ,NSString*> *) filterCustomDict: (NSDictionary<NSNumber* ,NSString*> *) dict{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSNumber *idx in dict) {
        if (idx.intValue > 0) {
            [result setObject:dict[idx] forKey:idx];
        }
    }
    return result;
}

- (BOOL) isEmpty: (NSArray<NSString*>*) objects {
    for (NSString* object in objects) {
        if (![object isEqualToString:@""]) {
            return false;
        }
    }
    return true;
}

@end
