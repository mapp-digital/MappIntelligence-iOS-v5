//
//  MIURLSizeMonitorTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIURLSizeMonitor.h"

@interface MIURLSizeMonitorTests : XCTestCase

@property MIURLSizeMonitor* sizeMonitor;

@end

@implementation MIURLSizeMonitorTests

- (void)setUp {
    [super setUp];
    _sizeMonitor = [[MIURLSizeMonitor alloc] init];
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

