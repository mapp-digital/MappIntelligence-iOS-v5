//
//  MIEcommerceProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MIEcommerceParameters.h"

@implementation MIEcommerceParameters

- (instancetype)initWithCustomParameters:(NSDictionary<NSNumber *,NSString *> *)parameters {
    self = [super init];
    if (self) {
        _customParameters = parameters;
    }
    return self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    [items addObjectsFromArray:[self getProductsAsQueryItems]];
    
    if (_customParameters) {
        _customParameters = [self filterCustomDict:_customParameters];
        for(NSNumber* key in _customParameters) {
            NSMutableArray<NSString*>* customProps = [[_customParameters[key] componentsSeparatedByString:@";"] mutableCopy];
            NSLog(@"product conut: %lu, status: %d", (unsigned long)[_products count], [customProps count] < [_products count]);
            while ([customProps count] < [_products count]) {
                [customProps addObject:@""];
            }
            NSString* propsValue = [customProps componentsJoinedByString:@";"];
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: propsValue]];
        }
    }
    
    if (_currency) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cr" value:_currency]];
    }
    if (_orderID) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"oi" value:_orderID]];
    }
    if (_orderValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ov" value:[_orderValue stringValue]]];
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

- (void)setStatus:(Status)status {
    _status = status;
}

- (NSMutableArray<NSURLQueryItem *> *)getUserPredefinedPropertiesAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if (_returningOrNewCustomer) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb560" value:_returningOrNewCustomer]];
    }
    if (_returnValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb561" value:[_returnValue stringValue]]];
    }
    if (_cancellationValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb562" value:[_cancellationValue stringValue] ]];
    }
    if (_couponValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb563" value:[_couponValue stringValue] ]];
    }
    if (_productAdvertiseID) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb675" value:[_productAdvertiseID stringValue] ]];
    }
    if (_productSoldOut) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb760" value:[_productSoldOut stringValue]]];
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
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb764" value:[_shippingCost stringValue]]];
    }
    if (_markUp) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb765" value:[_markUp stringValue]]];
    }
    if (_orderStatus) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb766" value:_orderStatus]];
    }
    if (_productVariant) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb767" value:_productVariant]];
    }
    return items;
}

- (NSMutableArray<NSURLQueryItem *> *)getProductsAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if(_products) {
        NSMutableArray<NSString*>* productNames = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productCosts = [[NSMutableArray alloc] init];
        NSMutableArray<NSString*>* productQuantities = [[NSMutableArray alloc] init];
        NSMutableArray* categoriesKeys = [[NSMutableArray alloc] init];
        
        for (MIProduct* product in _products) {
            [productNames addObject: product.name];
            [productCosts addObject: (product.cost ? [product.cost stringValue] : @"")];
            [productQuantities addObject: (product.quantity ? [product.quantity stringValue] : @"")];
            [categoriesKeys addObjectsFromArray:product.categories.allKeys];
        }
        
        categoriesKeys = [[[NSSet setWithArray:categoriesKeys] allObjects] copy];
        
        NSMutableArray<NSString*>* tempCategories = [[NSMutableArray alloc] init];
        for (NSNumber* key in categoriesKeys) {
            [tempCategories removeAllObjects];
            for (MIProduct* product in _products) {
                NSString* tmpObject = [[[product categories] allKeys] containsObject:key] ? product.categories[key] : @"";
                [tempCategories addObject: tmpObject];
            }
            [items addObject:[[NSURLQueryItem alloc] initWithName:[@"ca" stringByAppendingString:[key stringValue]] value:[tempCategories componentsJoinedByString:@";"]]];
        }
        
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ba" value:[productNames componentsJoinedByString:@";"]]];
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"co" value:[productCosts componentsJoinedByString:@";"]]];
        if (_status != viewed) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:@"qn" value:[productQuantities componentsJoinedByString:@";"]]];
        }
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

@end
