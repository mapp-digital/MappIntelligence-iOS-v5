//
//  Product.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 30/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProduct.h"

#define key_name @"name"
#define key_cost @"cost"
#define key_quantity @"quantity"
#define key_product_variant @"productVariant"
#define key_product_advertise_id @"productAdvertiseID"
#define key_product_sold_out @"productSoldOut"
#define key_categories @"categories"
#define key_ecommerceParameters @"ecommerceParameters"

@interface ProductTests : XCTestCase

@property MIProduct* product;
@property MIProduct* productFromDictionary;
@property NSDictionary* dictionary;

@property NSString* productName;
@property NSNumber* cost;
@property NSNumber* quantity;
@property NSNumber* productAdvertiseID;
@property NSNumber* productSoldOut;
@property NSString* productVariant;

@end

@implementation ProductTests

- (void)setUp {
    [self setUpDictionary];
    _product = [[MIProduct alloc] init];
    _product.name = _productName;
    _product.cost = _cost;
    _product.quantity = _quantity;
    _product.productVariant = _productVariant;
    _product.productSoldOut = _productSoldOut;
    _product.productAdvertiseID = _productAdvertiseID;
    _productFromDictionary = [[MIProduct alloc] initWithDictionary:_dictionary];
}

- (void)setUpDictionary {
    _productName = @"Nokia";
    _cost = @44.99;
    _quantity = @3;
    _productAdvertiseID = @123456;
    _productSoldOut = @3;
    _productVariant = @"variant";
    
    _dictionary = @{key_name: _productName, key_cost: _cost, key_quantity: _quantity, key_product_advertise_id: _productAdvertiseID, key_product_sold_out: _productSoldOut, key_product_variant: _productVariant};
}

- (void)tearDown {
    _product = nil;
    _dictionary = nil;
    _productFromDictionary = nil;
}

- (void)testInit {
    [self checkProduct:_product];
}

- (void)testInitWithDictionary {
    [self checkProduct:_productFromDictionary];
}

-(void) checkProduct: (MIProduct*)tmpProduct {
    XCTAssertTrue([tmpProduct.name isEqualToString:_productName], @"Product has no good name property!" );
    XCTAssertTrue([tmpProduct.quantity isEqualToNumber:_quantity], @"Product has no good quantity property!" );
    XCTAssertTrue([tmpProduct.cost isEqualToNumber:_cost], @"Product has no good cost property!" );
    XCTAssertTrue([tmpProduct.productAdvertiseID isEqualToNumber:_productAdvertiseID], @"Product has no good productAdvertiseID property!" );
    XCTAssertTrue([tmpProduct.productSoldOut isEqualToNumber:_productSoldOut], @"Product has no good product sold out property!" );
    XCTAssertTrue([tmpProduct.productVariant isEqualToString:_productVariant], @"Product has no good product vairant property!" );
}

@end
