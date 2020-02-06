//
//  MappIntelligenceNetworkMetaDataTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 06/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceNetworkMetadata.h"

@interface MappIntelligenceNetworkMetaDataTests : XCTestCase

@end

@implementation MappIntelligenceNetworkMetaDataTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitialization
{
    XCTAssertNotNil([[MappIntelligenceNetworkMetadata alloc] initWithKeyedValues:nil]);
}

- (void)testInitializationWithKeyedValues
{
    NSString *msg = @"HTTP_Exception_403 [ 403 ]: Invalid credentials supplied ~ /var/www/html/appoxee/appoxee/core/classes/controller/api.php [ 83 ]";
    
    NSDictionary *response = @{@"metadata" : @{@"code" : @(403), @"error" : @(1), @"message" : msg}};
    
    MappIntelligenceNetworkMetadata *metadata = [[MappIntelligenceNetworkMetadata alloc] initWithKeyedValues:response[@"metadata"]];
    
    XCTAssertTrue([metadata.message isEqualToString:msg], @"Message is: %@", metadata.message);
    XCTAssertTrue((metadata.code == 403), @"code is: %tu", metadata.code);
    XCTAssertFalse(metadata.isSuccess);
}


@end
