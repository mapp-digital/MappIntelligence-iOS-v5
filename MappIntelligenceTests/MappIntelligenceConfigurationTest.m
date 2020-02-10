//
//  MappIntelligenceConfigurationTest.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 04/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceConfigurationTest : XCTestCase

@property (nonatomic) MappIntelligenceDefaultConfig *configuration;
@property (nonatomic, strong) NSDictionary *testDictionary;
@end

@implementation MappIntelligenceConfigurationTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertNotNil([[MappIntelligenceDefaultConfig alloc] init]);
}

-(void)testInitWithDictionary {
    NSDictionary *testDictionary = [[NSDictionary alloc] init];
    testDictionary = @{@"auto_tracking": @NO, @"batch_support": @YES, @"request_per_batch": @1223, @"requests_interval": @2123, @"log_level": @3, @"track_domain": @"dom.com",
                       @"track_ids": @"12133,123454", @"view_controller_auto_tracking": @NO};
    XCTAssertNotNil([[MappIntelligenceDefaultConfig alloc] initWithDictionary:testDictionary]);
}

-(void)testInitWithDictionaryWhitoutTrackIDs {
    NSDictionary *testDictionary = [[NSDictionary alloc] init];
    testDictionary = @{@"auto_tracking": @NO, @"batch_support": @YES, @"request_per_batch": @1223, @"requests_interval": @2123, @"log_level": @3, @"track_domain": @"dom.com",
                       @"track_ids": @"", @"view_controller_auto_tracking": @NO};
    XCTAssertEqual([testDictionary objectForKey:@"track_ids"], @"");
    XCTAssertNotNil([[MappIntelligenceDefaultConfig alloc] initWithDictionary:testDictionary]);
}

-(void)testInitWithDictionaryWhitoutTrackingDomain {
    
    NSDictionary *testDictionary = [[NSDictionary alloc] init];
    testDictionary = @{@"auto_tracking": @NO, @"batch_support": @YES, @"request_per_batch": @1223, @"requests_interval": @2123, @"log_level": @3, @"track_domain": @"",
                       @"track_ids": @"12133,123454", @"view_controller_auto_tracking": @NO};
    XCTAssertEqual([testDictionary objectForKey:@"track_domain"], @"");
    XCTAssertNotNil([[MappIntelligenceDefaultConfig alloc] initWithDictionary:testDictionary]);
    
}
@end
