//
//  MIMediaEventTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 1.10.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIMediaEvent.h"
#import "MIMediaParameters.h" // Make sure to import the MIMediaParameters class if it's needed.


@interface MIMediaEventTests : XCTestCase

@end

@implementation MIMediaEventTests

- (void)testInitializationWithValidParameters {
    // Arrange
    NSString *expectedPageName = @"TestPage";
    MIMediaParameters *parameters = [[MIMediaParameters alloc] initWith:@"TestMedia"
                                                                  action:@"play"
                                                                position:@(10)
                                                                duration:@(120)];

    // Act
    MIMediaEvent *event = [[MIMediaEvent alloc] initWithPageName:expectedPageName parameters:parameters];

    // Assert
    XCTAssertNotNil(event, @"MIMediaEvent should not be nil after initialization.");
    XCTAssertEqualObjects(event.pageName, expectedPageName, @"Page name should match the expected value.");
    XCTAssertEqual(event.mediaParameters, parameters, @"Media parameters should match the expected value.");
}

- (void)testInitializationWithNilPageName {
    // Arrange
    MIMediaParameters *parameters = [[MIMediaParameters alloc] initWith:@"TestMedia"
                                                                  action:@"play"
                                                                position:@(10)
                                                                duration:@(120)];

    // Act
    MIMediaEvent *event = [[MIMediaEvent alloc] initWithPageName:nil parameters:parameters];

    // Assert
    XCTAssertNotNil(event, @"MIMediaEvent should not be nil after initialization even with nil page name.");
    XCTAssertNil(event.pageName, @"Page name should be nil when initialized with a nil value.");
    XCTAssertEqual(event.mediaParameters, parameters, @"Media parameters should match the expected value.");
}

- (void)testInitializationWithNilParameters {
    // Arrange
    NSString *expectedPageName = @"TestPage";

    // Act
    MIMediaEvent *event = [[MIMediaEvent alloc] initWithPageName:expectedPageName parameters:nil];

    // Assert
    XCTAssertNotNil(event, @"MIMediaEvent should not be nil after initialization even with nil parameters.");
    XCTAssertEqualObjects(event.pageName, expectedPageName, @"Page name should match the expected value.");
    XCTAssertNil(event.mediaParameters, @"Media parameters should be nil when initialized with a nil value.");
}

@end
