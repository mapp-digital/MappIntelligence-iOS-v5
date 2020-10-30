//
//  EcommerceProperties.m
//  MappIntelligenceSDK
//
//  Created by Stefan Stevanovic on 26/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "EcommerceProperties.h"

@implementation EcommerceProperties

- (instancetype)initWithCustomProperties:(NSDictionary<NSNumber *,NSArray<NSString *> *> *)properties {
    self = [super init];
    if (self) {
        _customProperties = properties;
    }
    return self;
}

- (NSMutableArray<NSURLQueryItem *> *)asQueryItems {
    
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    [items addObjectsFromArray:[self getProductsAsQueryItems]];
    
    if (_customProperties) {
        _customProperties = [self filterCustomDict:_customProperties];
        for(NSNumber* key in _customProperties) {
            [items addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: [_customProperties[key] componentsJoinedByString:@";"]]];
        }
    }
    
    if (_currencyCode) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"cr" value:_currencyCode]];
    }
    if (_orderNumber) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"oi" value:_orderNumber]];
    }
    if (_orderValue) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"ov" value:_orderValue]];
    }
    if (_status) {
        [items addObject:[[NSURLQueryItem alloc] initWithName:@"st" value:[self getStatus]]];
    }
    
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
        case list:
            return @"list";
            break;
        default:
            return @"view";
    }
}

- (NSMutableArray<NSURLQueryItem *> *)getProductsAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    NSMutableArray<NSString*>* productNames = [[NSMutableArray alloc] init];
    NSMutableArray<NSString*>* productCosts = [[NSMutableArray alloc] init];
    NSMutableArray<NSString*>* productQuantities = [[NSMutableArray alloc] init];
    
    for (Product* product in _products) {
        [productNames addObject: product.name];
        [productCosts addObject: product.price];
        [productQuantities addObject: (product.quantity == NULL) ? @"" : [product.quantity stringValue]];
    }
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"ba" value:[productNames componentsJoinedByString:@";"]]];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"co" value:[productCosts componentsJoinedByString:@";"]]];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"qn" value:[productQuantities componentsJoinedByString:@";"]]];
    
    return items;
}

- (NSDictionary<NSNumber* ,NSArray<NSString*>*> *) filterCustomDict: (NSDictionary<NSNumber* ,NSArray<NSString*>*> *) dict{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    for (NSNumber *idx in dict) {
        if (idx.intValue < 500 && idx.intValue > 0) {
            [result setObject:dict[idx] forKey:idx];
        }
    }
    return result;
    
}

@end
