//
//  EcommercePropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 30/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
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
@property NSNumberFormatter* formatter;
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
    _formatter = [[MappIntelligenceLogger shared] formatter];
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
    NSDictionary* dictionary = @{key_products: [self setProducts], key_status: [NSNumber numberWithLong:(long)_status], key_currency: _currency, key_order_id: _orderID, key_order_value: _orderValue, key_returning_or_new_customer: _returningOrNewCustomer, key_return_value: _returnValue, key_cancellation_value: _cancellationValue, key_coupon_value: _couponValue, key_payment_method: _paymentMethod, key_shipping_service_provider: _shippingServiceProvider, key_shippingSpeed: _shippingSpeed, key_shipping_cost: _shippingCost, key_mark_up: _markUp, key_order_status: _orderStatus, key_custom_parameters: _properties};
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
    NSMutableDictionary* tempDictionary = [[NSMutableDictionary alloc] init];
    if (product.name) {
        [tempDictionary addEntriesFromDictionary:@{key_name: product.name}];
    }
    if (product.cost) {
        [tempDictionary addEntriesFromDictionary:@{key_cost: product.cost}];
    }
    if (product.quantity) {
        [tempDictionary addEntriesFromDictionary:@{key_quantity: product.quantity}];
    }
    return tempDictionary;
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
    
    for (int i = 0; i < [object.products count]; i++)
    {
        XCTAssertTrue([object.products[i] isEqual:_products[i]], @"The product is not correct!");
    }
    XCTAssertTrue([object.customParameters isEqualToDictionary:_properties], @"The custom parameters is not correct!");
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

- (void)testAsQueryItems {
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    
    [expectedItems addObjectsFromArray:[self getProductsAsQueryItems]];
    
    if (_properties) {
        _properties = [[self filterCustomDict:_properties] copy];
        for(NSNumber* key in _properties) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cb%@",key] value: _properties[key]]];
        }
    }
    
    if (_currency) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"cr" value:_currency]];
    }
    if (_orderID) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"oi" value:_orderID]];
    }
    if (_orderValue) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"ov" value:[_formatter stringFromNumber:_orderValue]]];
    }
    if (_status) {
        [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"st" value:[self getStatus]]];
    }
    
    [expectedItems addObjectsFromArray:[self getProductsAsQueryItems]];
    
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

- (BOOL) isEmpty: (NSArray<NSString*>*) objects {
    for (NSString* object in objects) {
        if (![object isEqualToString:@""]) {
            return false;
        }
    }
    return true;
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


- (void)testInitWithCustomParameters {
    NSDictionary<NSNumber*, NSString*>* customParameters = @{@1: @"testValue"};
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] initWithCustomParameters:customParameters];
    
    XCTAssertEqual(ecommerceParams.customParameters[@1], @"testValue", @"Custom parameters should be set correctly");
}

- (void)testInitWithDictionaryCustom {
    NSDictionary *dict = @{
        key_currency: @"USD",
        key_order_id: @"12345",
        key_order_value: @100.99,
        key_status: @2,
        key_products: @[@{@"name": @"TestProduct", @"cost": @49.99}],
    };
    
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] initWithDictionary:dict];
    
    XCTAssertEqualObjects(ecommerceParams.currency, @"USD", @"Currency should be USD");
    XCTAssertEqualObjects(ecommerceParams.orderID, @"12345", @"Order ID should be 12345");
    XCTAssertEqual([ecommerceParams.orderValue doubleValue], 100.99, @"Order value should be 100.99");
    XCTAssertEqual(ecommerceParams.status, purchased, @"Status should be set to 'purchased'");
    XCTAssertEqual(ecommerceParams.products.count, 1, @"There should be 1 product in the list");
}

- (void)testSetStatus {
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] init];
    
    // Test setting different statuses and checking the getStatus conversion
    [ecommerceParams setStatus:addedToBasket];
    XCTAssertEqual(ecommerceParams.status, addedToBasket, @"Status should be set to 'addedToBasket'");
    
    [ecommerceParams setStatus:viewed];
    XCTAssertEqual(ecommerceParams.status, viewed, @"Status should be set to 'viewed'");
    
    [ecommerceParams setStatus:checkout];
    XCTAssertEqual(ecommerceParams.status, checkout, @"Status should be set to 'checkout'");
}

- (void)testAsQueryItemsWithStatus {
    // Test if status is correctly converted into query items
    NSDictionary *dict = @{
        key_currency: @"USD",
        key_order_id: @"12345",
        key_order_value: @100.99,
        key_status: @1, // Testing addedToBasket
    };
    
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] initWithDictionary:dict];
    
    NSMutableArray<NSURLQueryItem*> *queryItems = [ecommerceParams asQueryItems];
    
    // Verify the 'st' query item reflects the correct status
    NSURLQueryItem *statusItem = [self getQueryItemWithName:@"st" fromItems:queryItems];
    XCTAssertEqualObjects(statusItem.value, @"add", @"Status should be 'add' for 'addedToBasket'");
}

- (void)testAsQueryItemsWithBasicData {
    NSDictionary *dict = @{
        key_currency: @"USD",
        key_order_id: @"12345",
        key_order_value: @100.99,
        key_status: @2,
    };
    
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] initWithDictionary:dict];
    
    NSMutableArray<NSURLQueryItem*> *queryItems = [ecommerceParams asQueryItems];
    
    XCTAssertEqual(queryItems.count, 4, @"There should be 4 query items (currency, orderID, orderValue, status)");
    
    NSURLQueryItem *currencyItem = [self getQueryItemWithName:@"cr" fromItems:queryItems];
    XCTAssertEqualObjects(currencyItem.value, @"USD", @"Currency should be set to USD");
    
    NSURLQueryItem *orderIDItem = [self getQueryItemWithName:@"oi" fromItems:queryItems];
    XCTAssertEqualObjects(orderIDItem.value, @"12345", @"Order ID should be set to 12345");
    
    NSURLQueryItem *orderValueItem = [self getQueryItemWithName:@"ov" fromItems:queryItems];
    XCTAssertEqualObjects(orderValueItem.value, @"100.99", @"Order value should be set to 100.99");
    
    NSURLQueryItem *statusItem = [self getQueryItemWithName:@"st" fromItems:queryItems];
    XCTAssertEqualObjects(statusItem.value, @"conf", @"Status should be set to 'conf' for 'purchased'");
}

- (void)testProductHandling {
    NSDictionary *productDict = @{
        @"name": @"TestProduct",
        @"cost": @49.99,
        @"quantity": @1,
    };
    
    MIProduct *product = [[MIProduct alloc] initWithDictionary:productDict];
    
    MIEcommerceParameters *ecommerceParams = [[MIEcommerceParameters alloc] init];
    ecommerceParams.products = [NSMutableArray arrayWithObject:product];
    
    NSMutableArray<NSURLQueryItem*> *queryItems = [ecommerceParams asQueryItems];
    
    NSURLQueryItem *productNameItem = [self getQueryItemWithName:@"ba" fromItems:queryItems];
    XCTAssertEqualObjects(productNameItem.value, @"TestProduct", @"Product name should be 'TestProduct'");
    
    NSURLQueryItem *productCostItem = [self getQueryItemWithName:@"co" fromItems:queryItems];
    XCTAssertEqualObjects(productCostItem.value, @"49.99", @"Product cost should be '49.99'");
    
    NSURLQueryItem *productQuantityItem = [self getQueryItemWithName:@"qn" fromItems:queryItems];
    XCTAssertEqualObjects(productQuantityItem.value, @"1", @"Product quantity should be '1'");
}

#pragma mark - Helper Methods

- (NSURLQueryItem*)getQueryItemWithName:(NSString*)name fromItems:(NSArray<NSURLQueryItem*>*)items {
    for (NSURLQueryItem *item in items) {
        if ([item.name isEqualToString:name]) {
            return item;
        }
    }
    return nil;
}

@end
