//
//  URLSizeMonitorTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/8/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
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

- (void)testCutPParameterLegth {
    NSString *library = @"cutPParameterLegth";
    NSString *contentID = @"testCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringName";
    NSString *size = @"1125x2436";
    double stamp = 1586522540579.0879;
    NSString *pParameter = [[NSString alloc] initWithFormat:@"%@,%@,0,%@,32,0,%.f,0,0,0", library, contentID, size, stamp];
    XCTAssertTrue([pParameter length] > 255, @"p parameter is greater than 255 characters");
    pParameter = [_sizeMonitor cutPParameterLegth:library pageName:contentID andScreenSize:size andTimeStamp:stamp];
    XCTAssertTrue([pParameter length] == 255, @"p parameter is greater than 255 characters");
}
@end
