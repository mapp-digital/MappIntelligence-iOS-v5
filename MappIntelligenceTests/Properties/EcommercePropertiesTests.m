//
//  EcommercePropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 30/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIEcommerceParameters.h"

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

//we need this for creating product dictionary
#define key_name @"name"
#define key_cost @"cost"
#define key_quantity @"quantity"
#define key_product_variant @"productVariant"
#define key_product_advertise_id @"productAdvertiseID"
#define key_product_sold_out @"productSoldOut"
#define key_categories @"categories"
#define key_ecommerceParameters @"ecommerceParameters"

@interface EcommercePropertiesTests : XCTestCase

@property MIEcommerceParameters* ecommerceProperties;
@property MIEcommerceParameters* ecommercePropertiesFromDictionary;
@property NSMutableDictionary* properties;
@property NSArray<MIProduct* >* products;

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

@end

@implementation EcommercePropertiesTests

- (void)setUp {
    _properties = [@{@1:@"testValue;"} copy];
    _ecommerceProperties = [[MIEcommerceParameters alloc] initWithCustomParameters:_properties];
    MIProduct *product1 = [[MIProduct alloc] init];
    product1.name = @"product1Name";
    product1.quantity = [NSNumber numberWithInt:33];
    MIProduct *product2 = [[MIProduct alloc] init];
    product2.name = @"product2Name";
    product2.quantity = [NSNumber numberWithInt:44];
    _products = [NSArray arrayWithObjects:product1, product2, nil];
    
    _status = viewed;
     _currency = @"EUR";
     _orderID = @"iorejlkn";
     _orderValue = @879;
     //new values
     _returningOrNewCustomer = @"returning";
     _returnValue = @5;
     _cancellationValue = @6;
     _couponValue = @7;
     _paymentMethod = @"VISA";
     _shippingServiceProvider = @"DHL";
     _shippingSpeed = @"150kmph";
     _shippingCost = @34;
     _markUp = @8;
     _orderStatus = @"delievered";
    
    _ecommerceProperties.products = _products;
    _ecommerceProperties.status = _status;
    _ecommerceProperties.currency = _currency;
    _ecommerceProperties.orderID = _orderID;
    _ecommerceProperties.orderValue = _orderValue;
    _ecommerceProperties.returningOrNewCustomer = _returningOrNewCustomer;
    _ecommerceProperties.returnValue = _returnValue;
    _ecommerceProperties.cancellationValue = _cancellationValue;
    _ecommerceProperties.couponValue = _couponValue;
    _ecommerceProperties.paymentMethod = _paymentMethod;
    _ecommerceProperties.shippingServiceProvider = _shippingServiceProvider;
    _ecommerceProperties.shippingSpeed = _shippingSpeed;
    _ecommerceProperties.shippingCost = _shippingCost;
    _ecommerceProperties.markUp = _markUp;
    _ecommerceProperties.orderStatus = _orderStatus;
    
    //crate dictionary for ecommerce object
    NSDictionary* dictionary = @{key_products: [self setProducts], key_status: [NSNumber numberWithLong:(long)_status], key_currency: _currency, key_order_id: _orderID, key_order_value: _orderValue, key_returning_or_new_customer: _returningOrNewCustomer, key_return_value: _returnValue, key_cancellation_value: _cancellationValue, key_coupon_value: _couponValue, key_payment_method: _paymentMethod, key_shipping_service_provider: _shippingServiceProvider, key_shippingSpeed: _shippingSpeed, key_shipping_cost: _shippingCost, key_mark_up: _markUp, key_order_status: _orderStatus};
    _ecommercePropertiesFromDictionary = [[MIEcommerceParameters alloc] initWithDictionary:dictionary];
}

- (NSArray<NSDictionary*>*)setProducts {
    NSMutableArray<NSDictionary*>* tempArray = [[NSMutableArray alloc] init];
    for (MIProduct* product in _products) {
        [tempArray addObject:[self dictionaryFromProduct:product]];
    }
    return tempArray;
}

- (NSDictionary*) dictionaryFromProduct: (MIProduct*) product {
    return @{key_name: product.name, key_cost: product.cost, key_quantity: product.quantity};
}

- (void)tearDown {
    _ecommerceProperties = nil;
    _properties = nil;
    _products = nil;
    _couponValue = nil;
}

- (void)testInitWithCustomProperties {
    XCTAssertTrue([_ecommerceProperties.customParameters isEqual:_properties], @"The custom properties are not correct!");
    XCTAssertTrue([_ecommerceProperties.products isEqual:_products], "The list of products is not correct!");
    XCTAssertTrue([_ecommerceProperties.couponValue isEqual:_couponValue], "The cupon value is not correct!");
}

- (void) testInitWithDictionary {
    [self chectEcommerceObject:_ecommercePropertiesFromDictionary];
}

- (void) chectEcommerceObject: (MIEcommerceParameters*) object {
    XCTAssertTrue([[NSNumber numberWithLong:(long)object.status] isEqualToNumber:[NSNumber numberWithLong:(long)_status]], @"The status is not correct!");
    XCTAssertTrue([object.currency isEqualToString:_currency], @"The currency is not correct!");
    XCTAssertTrue([object.orderID isEqualToString:_orderID], @"The order ID is not correct!");
    XCTAssertTrue([object.orderValue isEqualToNumber:_orderValue], @"The order value is not correct!");
    XCTAssertTrue([object.returningOrNewCustomer isEqualToString:_returningOrNewCustomer], @"The returning or new customer is not correct!");
    XCTAssertTrue([object.returnValue isEqualToNumber:_returnValue], @"The return value is not correct!");
    XCTAssertTrue([object.cancellationValue isEqualToNumber:_cancellationValue], @"The cancellation value is not correct!");
    XCTAssertTrue([object.couponValue isEqualToNumber:_couponValue], @"The coupon value is not correct!");
    XCTAssertTrue([object.paymentMethod isEqualToString:_paymentMethod], @"The payment method is not correct!");
    XCTAssertTrue([object.shippingServiceProvider isEqualToString:_shippingServiceProvider], @"The shipping service provider is not correct!");
    XCTAssertTrue([object.shippingSpeed isEqualToString:_shippingSpeed], @"The shipping speed provider is not correct!");
    XCTAssertTrue([object.shippingCost isEqualToNumber:_shippingCost], @"The shipping cost provider is not correct!");
    XCTAssertTrue([object.shippingCost isEqualToNumber:_shippingCost], @"The shipping cost provider is not correct!");
    XCTAssertTrue([object.markUp isEqualToNumber:_markUp], @"The markup is not correct!");
    XCTAssertTrue([object.orderStatus isEqualToString:_orderStatus], @"The order status is not correct!");
    
    XCTAssertTrue([object.products isEqualToArray:_products], @"The products is not correct!");
    XCTAssertTrue([object.customParameters isEqualToDictionary:_properties], @"The custom parameters is not correct!");
}

- (void)testAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    
    //custom properties
    if (_properties) {
        for(NSNumber* key in _properties) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: _properties[key]]];
        }
    }
    //products
    [expectedItems addObjectsFromArray:[self getProductsAsQueryItems]];
    //cupon value
    if (_couponValue) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"cb563" value:[_couponValue stringValue] ]];
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
        
        for (MIProduct* product in _products) {
            [productNames addObject: product.name];
            [productCosts addObject: product.cost ? [product.cost stringValue] : @""];
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
