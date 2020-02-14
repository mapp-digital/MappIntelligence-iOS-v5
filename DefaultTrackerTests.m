//
//  DefaultTrackerTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 14/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligence/Trackers/DefaultTracker.h"

@interface DefaultTrackerTests : XCTestCase

@end

@implementation DefaultTrackerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil([[DefaultTracker alloc] init]);
}

- (void)testGenerateEverID {
    DefaultTracker * tracker = [[DefaultTracker alloc] init];
    XCTAssertNotNil([tracker generateEverId]);
}

- (void)testGenerateEverIDformat
{
    DefaultTracker *tracker = [[DefaultTracker alloc] init];
    
    NSString *generatedEverID = [tracker generateEverId];
    XCTAssert([generatedEverID hasPrefix:@"6"], @"Ever ID should start with 6.");
    XCTAssertEqual(generatedEverID.length, 19, @"Ever ID should have 19 digits");
}


@end
