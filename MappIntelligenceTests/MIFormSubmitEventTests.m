//
//  MIFormSubmitEventTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 1.10.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormSubmitEvent.h"

@interface MIFormSubmitEventTests : XCTestCase

@end

@implementation MIFormSubmitEventTests

- (void)testInitialization {
    // Act
    MIFormSubmitEvent *formSubmitEvent = [[MIFormSubmitEvent alloc] init];
    [formSubmitEvent setPageName: @"name"];

    // Assert
    XCTAssertNotNil(formSubmitEvent, @"MIFormSubmitEvent should not be nil after initialization.");
    XCTAssertNotNil(formSubmitEvent.pageName, @"Page name should not be nil after initialization.");
    XCTAssertEqual(formSubmitEvent.pageName, @"name");
}


@end
