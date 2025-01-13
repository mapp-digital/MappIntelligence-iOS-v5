//
//  APXNetworkMetadataTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APXNetworkMetadata.h"

@interface MINetworkMetadataTests : XCTestCase
@end

@implementation MINetworkMetadataTests

// Test valid initialization with a dictionary
- (void)testInitWithKeyedValues_ValidData {
    NSDictionary *keyedValues = @{
        @"code": @200,
        @"error": @NO,
        @"message": @"Success"
    };
    
    MINetworkMetadata *metadata = [[MINetworkMetadata alloc] initWithKeyedValues:keyedValues];
    
    XCTAssertEqual(metadata.code, 200, @"Code should be 200");
    XCTAssertTrue(metadata.succes, @"Succes should be YES (true) when error is NO");
    XCTAssertEqualObjects(metadata.message, @"Success", @"Message should be 'Success'");
}

// Test initialization with error data
- (void)testInitWithKeyedValues_ErrorData {
    NSDictionary *keyedValues = @{
        @"code": @400,
        @"error": @YES,
        @"message": @"Bad Request"
    };
    
    MINetworkMetadata *metadata = [[MINetworkMetadata alloc] initWithKeyedValues:keyedValues];
    
    XCTAssertEqual(metadata.code, 400, @"Code should be 400");
    XCTAssertFalse(metadata.succes, @"Succes should be NO (false) when error is YES");
    XCTAssertEqualObjects(metadata.message, @"Bad Request", @"Message should be 'Bad Request'");
}

// Test initialization with missing fields
- (void)testInitWithKeyedValues_MissingFields {
    NSDictionary *keyedValues = @{
        @"code": @500
        // "error" and "message" are missing
    };
    
    MINetworkMetadata *metadata = [[MINetworkMetadata alloc] initWithKeyedValues:keyedValues];
    XCTAssertEqual(metadata.code, 500, @"Code should be 500");
    XCTAssertFalse(metadata.succes, @"Succes should be NO (false) by default if 'error' is missing");
    XCTAssertNil(metadata.message, @"Message should be nil if not provided");
}

// Test initialization with empty dictionary
- (void)testInitWithKeyedValues_EmptyDictionary {
    NSDictionary *keyedValues = @{};
    
    MINetworkMetadata *metadata = [[MINetworkMetadata alloc] initWithKeyedValues:keyedValues];
    
    XCTAssertEqual(metadata.code, 0, @"Code should be 0 if not provided");
    XCTAssertFalse(metadata.succes, @"Succes should be NO (false) by default if 'error' is missing");
    XCTAssertNil(metadata.message, @"Message should be nil if not provided");
}

// Test initialization with nil dictionary
- (void)testInitWithKeyedValues_NilDictionary {
    MINetworkMetadata *metadata = [[MINetworkMetadata alloc] initWithKeyedValues:nil];
    
    XCTAssertEqual(metadata.code, 0, @"Code should be 0 if no data is provided");
    XCTAssertFalse(metadata.succes, @"Succes should be NO (false) by default if 'error' is missing");
    XCTAssertNil(metadata.message, @"Message should be nil if no data is provided");
}

@end

