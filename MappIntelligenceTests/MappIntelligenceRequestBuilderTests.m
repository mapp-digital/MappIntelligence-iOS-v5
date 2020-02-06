//
//  MappIntelligenceRequestBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 06/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceRequestBuilder.h"

@interface MappIntelligenceRequestBuilderTests : XCTestCase

@end

@implementation MappIntelligenceRequestBuilderTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testManagerIsInitialized
{
    XCTAssertNotNil([MappIntelligenceRequestBuilder shared]);
    MappIntelligenceRequestBuilder *builder = [MappIntelligenceRequestBuilder builder];
    XCTAssertNotNil(builder);
}

- (void)testAddingNilValues
{
    MappIntelligenceRequestBuilder *builder = [MappIntelligenceRequestBuilder builder];
    [builder addRequestKeyedValues:nil forRequestType:kMappIntelligenceRequestKeyTypeApplicationConfiguration];
    
    NSData *data = [builder buildRequestAsJsonData];
    
    XCTAssertNil(data);
}

- (void)testAddingNilValuesSingleton
{
    [[MappIntelligenceRequestBuilder shared] addRequestKeyedValues:nil forRequestType:kMappIntelligenceRequestKeyTypeApplicationConfiguration];
    
    NSData *data = [[MappIntelligenceRequestBuilder shared] buildRequestAsJsonData];
    
    XCTAssertNil(data);
}

- (void)testRequestWithNoValuesSingletone
{
    NSData *data = [[MappIntelligenceRequestBuilder shared] buildRequestAsJsonData];
    
    XCTAssertNil(data);
}

- (void)testRequestWithNoValues
{
    MappIntelligenceRequestBuilder *builder = [MappIntelligenceRequestBuilder builder];
    NSData *data = [builder buildRequestAsJsonData];
    
    XCTAssertNil(data);
}



@end
