//
//  MIParamTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 19.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


#import <XCTest/XCTest.h>
#import "MIParams.h"

@interface MIParamsTests : XCTestCase

@end

@implementation MIParamsTests

- (void)testInternalSearch {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams internalSearch];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by internalSearch should be '%@'.", expectedValue);
}

- (void)testMediaCode {
    NSString *expectedValue = @"mc";
    NSString *result = [MIParams mediaCode];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by mediaCode should be '%@'.", expectedValue);
}

- (void)testCustomerId {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams customerId];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by customerId should be '%@'.", expectedValue);
}

- (void)testProductName {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams productName];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by productName should be '%@'.", expectedValue);
}

- (void)testProductCost {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams productCost];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by productCost should be '%@'.", expectedValue);
}

- (void)testProductCurrency {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams productCurrency];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by productCurrency should be '%@'.", expectedValue);
}

- (void)testProductQuantity {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams productQuantity];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by productQuantity should be '%@'.", expectedValue);
}

- (void)testStatusOfShoppingCard {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams statusOfShoppingCard];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by statusOfShoppingCard should be '%@'.", expectedValue);
}

- (void)testOrderId {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams orderId];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by orderId should be '%@'.", expectedValue);
}

- (void)testOrderValue {
    NSString *expectedValue = @"is";
    NSString *result = [MIParams orderValue];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by orderValue should be '%@'.", expectedValue);
}

@end
