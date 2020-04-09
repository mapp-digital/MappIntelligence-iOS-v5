//
//  URLSizeMonitorTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/8/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "URLSizeMonitor.h"

@interface URLSizeMonitorTests : XCTestCase

@property URLSizeMonitor* sizeMonitor;

@end

@implementation URLSizeMonitorTests

- (void)setUp {
    [super setUp];
    _sizeMonitor = [[URLSizeMonitor alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAddSize {
    int previousSize = [_sizeMonitor currentRequestSize];
    [_sizeMonitor addSize:50];
    XCTAssertLessThan(previousSize, [_sizeMonitor currentRequestSize]);
}
@end
