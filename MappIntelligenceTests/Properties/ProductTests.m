//
//  Product.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 30/10/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProduct.h"

@interface ProductTests : XCTestCase

@property MIProduct* product;

@end

@implementation ProductTests

- (void)setUp {
    _product = [[MIProduct alloc] init];
}

- (void)tearDown {
    _product = nil;
}

- (void)testInit {
    _product.name = @"testName";
    XCTAssertTrue([_product.name isEqualToString:@"testName"], @"Product has no good name property!" );
//    _product.price = @"55$";
//    NSComparisonResult result = [_product.price compare:@"55$" options:NSWidthInsensitiveSearch];
//    XCTAssertTrue([_product.price isEqualToString:@"55$"], @"Product has no good price property!");
    _product.quantity = [[NSNumber alloc] initWithInteger:44];
    XCTAssertTrue([_product.quantity isEqualToNumber:[[NSNumber alloc] initWithInteger:44]], @"Product has no good quantity property!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
