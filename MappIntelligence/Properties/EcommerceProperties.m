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
    
    return items;
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

@end
