//
//  MappIntelligenceDefaultConfigTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceDefaultConfigTests : XCTestCase

@property MappIntelligenceDefaultConfig *config;

@end

@implementation MappIntelligenceDefaultConfigTests

- (void)setUp {
    [super setUp];
    _config = [[MappIntelligenceDefaultConfig alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testlogConfig {
    XCTAssertNotNil(_config);
    [_config logConfig];
}

@end
