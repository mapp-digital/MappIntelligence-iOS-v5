//
//  EcommercePropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 30/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIEcommerceProperties.h"

@interface EcommercePropertiesTests : XCTestCase

@property MIEcommerceProperties* ecommerceProperties;
@property NSMutableDictionary* properties;
@property NSArray<Product* >* products;
@property NSNumber* cuponValue;

@end

@implementation EcommercePropertiesTests

- (void)setUp {
    _properties = [@{@1:@[@"testValue"]} copy];
    _ecommerceProperties = [[MIEcommerceProperties alloc] initWithCustomProperties:_properties];
    Product *product1 = [[Product alloc] init];
    product1.name = @"product1Name";
    product1.price = @"55$";
    product1.quantity = [NSNumber numberWithInt:33];
    Product *product2 = [[Product alloc] init];
    product2.name = @"product2Name";
    product2.price = @"66$";
    product2.quantity = [NSNumber numberWithInt:44];
    _products = [NSArray arrayWithObjects:product1, product2, nil];
    _ecommerceProperties.products = _products;
    _cuponValue = [NSNumber numberWithInt: 101];
    _ecommerceProperties.cuponValue = _cuponValue;
}

- (void)tearDown {
    _ecommerceProperties = nil;
    _properties = nil;
    _products = nil;
    _cuponValue = nil;
}

- (void)testInitWithCustomProperties {
    XCTAssertTrue([_ecommerceProperties.customProperties isEqual:_properties], @"The custom properties are not correct!");
    XCTAssertTrue([_ecommerceProperties.products isEqual:_products], "The list of products is not correct!");
    XCTAssertTrue([_ecommerceProperties.cuponValue isEqual:_cuponValue], "The cupon value is not correct!");
}

- (void)testAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    
    //custom properties
    if (_properties) {
        for(NSNumber* key in _properties) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: [_properties[key] componentsJoinedByString:@";"]]];
        }
    }
    //products
    [expectedItems addObjectsFromArray:[self getProductsAsQueryItems]];
    //cupon value
    if (_cuponValue) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"cb563" value:[_cuponValue stringValue] ]];
    }
    
    NSMutableSet* set1 = [NSMutableSet setWithArray:expectedItems];
    NSMutableSet* set2 = [NSMutableSet setWithArray:[_ecommerceProperties asQueryItems]];
    [set1 minusSet:set2];
    NSArray* result = [set1 allObjects];
    XCTAssertTrue([result count] == 0, @"Query items are not as an expected!");
}

- (NSMutableArray<NSURLQueryItem *> *)getProductsAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray alloc] init];
    
    if(_products) {
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
    }
    
    return items;
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
