//
//  MIParamTypeTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 19.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "MIParamType.h"

@interface MIParamTypeTests : XCTestCase

@end

@implementation MIParamTypeTests

- (void)testPageParam {
    NSString *expectedValue = @"cp";
    NSString *result = [MIParamType pageParam];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by pageParam should be '%@'.", expectedValue);
}

- (void)testPageCategory {
    NSString *expectedValue = @"cg";
    NSString *result = [MIParamType pageCategory];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by pageCategory should be '%@'.", expectedValue);
}

- (void)testEcommerceParam {
    NSString *expectedValue = @"cb";
    NSString *result = [MIParamType ecommerceParam];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by ecommerceParam should be '%@'.", expectedValue);
}

- (void)testProductCategory {
    NSString *expectedValue = @"ca";
    NSString *result = [MIParamType productCategory];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by productCategory should be '%@'.", expectedValue);
}

- (void)testEventParam {
    NSString *expectedValue = @"ck";
    NSString *result = [MIParamType eventParam];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by eventParam should be '%@'.", expectedValue);
}

- (void)testCampaignParam {
    NSString *expectedValue = @"cc";
    NSString *result = [MIParamType campaignParam];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by campaignParam should be '%@'.", expectedValue);
}

- (void)testSessionParam {
    NSString *expectedValue = @"cs";
    NSString *result = [MIParamType sessionParam];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by sessionParam should be '%@'.", expectedValue);
}

- (void)testUrmCategory {
    NSString *expectedValue = @"uc";
    NSString *result = [MIParamType urmCategory];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by urmCategory should be '%@'.", expectedValue);
}

- (void)testCreateCustomParam {
    NSString *type = @"custom";
    NSInteger value = 42;
    NSString *expectedValue = @"custom42";
    NSString *result = [MIParamType createCustomParam:type value:value];
    XCTAssertEqualObjects(result, expectedValue, @"The value returned by createCustomParam should be '%@'.", expectedValue);
}

@end
