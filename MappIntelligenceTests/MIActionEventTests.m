//
//  ActionEventTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 10/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIActionEvent.h"

@interface MIActionEventTests : XCTestCase
@property NSMutableDictionary* details;
@property MIActionEvent* actionEvent;
@property MIEventParameters* actionProperties;
@property NSMutableDictionary *sessionDictionary;
@property MISessionParameters *sessionProperties;
@property MIUserCategories *userProperties;
@property MIEcommerceParameters *ecommerceProperties;
@property MICampaignParameters *advertisementProperties;

@end

@implementation MIActionEventTests

- (void)setUp {
    _details = [@{@20: @"ck20Override"} copy];
    _actionProperties = [[MIEventParameters alloc] initWithParameters: _details];
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[MISessionParameters alloc] initWithParameters: _sessionDictionary];
    _userProperties = [[MIUserCategories alloc] init];
    _userProperties.city = @"Berlin";
    _ecommerceProperties = [[MIEcommerceParameters alloc] init];
    MIProduct* product1 = [[MIProduct alloc] init];
    product1.name = @"product1";
    product1.quantity = [[NSNumber alloc] initWithInteger:22];
    MIProduct* product2 = [[MIProduct alloc] init];
    product2.name = @"product2";
    _ecommerceProperties.products = [[NSArray alloc] initWithObjects:product1, product2, nil];
    _advertisementProperties = [[MICampaignParameters alloc] initWith: @"en.internal.newsletter.2017.05"];
    _advertisementProperties.mediaCode = @"abc";
    _advertisementProperties.oncePerSession = YES;
    _advertisementProperties.action = view;
    _advertisementProperties.customParameters = @{@1: @[@"ECOMM"]};
    _actionEvent = [[MIActionEvent alloc] initWithName:@"TestAction"];
    _actionEvent.eventParameters = _actionProperties;
    _actionEvent.sessionParameters = _sessionProperties;
    _actionEvent.userCategories = _userProperties;
    _actionEvent.ecommerceParameters = _ecommerceProperties;
    _actionEvent.campaignParameters = _advertisementProperties;
}

- (void)tearDown {
    _actionEvent = nil;
    _details = nil;
    _sessionProperties = nil;
    _actionProperties = nil;
    _sessionDictionary = nil;
    _ecommerceProperties = nil;
    _userProperties = nil;
    _advertisementProperties = nil;
}

- (void)testInitWithProperties {
    XCTAssertTrue([[_actionEvent eventParameters] isEqual:_actionProperties], @"Action properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent sessionParameters] isEqual:_sessionProperties], @"Session properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent userCategories] isEqual:_userProperties], @"User properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent ecommerceParameters] isEqual: _ecommerceProperties], @"Ecommerce properties is not the same as it used for creation of page view event!");
    XCTAssertTrue([[_actionEvent campaignParameters] isEqual: _advertisementProperties], @"Advertisement properties is not the same as it used for creation of page view event!");
}

- (void)testInitializationWithName {
    // Arrange
    NSString *expectedName = @"TestAction";

    // Act
    MIActionEvent *actionEvent = [[MIActionEvent alloc] initWithName:expectedName];

    // Assert
    XCTAssertNotNil(actionEvent, @"MIActionEvent should not be nil after initialization.");
    XCTAssertEqualObjects(actionEvent.name, expectedName, @"Name should match the expected value.");
}

- (void)testPageName {
    // Arrange
    MIActionEvent *actionEvent = [[MIActionEvent alloc] initWithName:@"TestAction"];

    // Act
    NSString *pageName = actionEvent.pageName;

    // Assert
    XCTAssertEqualObjects(pageName, @"0", @"Page name should always return '0'.");
}

- (void)testAsQueryItemsWithName {
    // Arrange
    NSString *name = @"TestAction";
    MIActionEvent *actionEvent = [[MIActionEvent alloc] initWithName:name];

    // Act
    NSMutableArray<NSURLQueryItem *> *queryItems = [actionEvent asQueryItems];

    // Assert
    XCTAssertNotNil(queryItems, @"Query items should not be nil.");
    XCTAssertEqual(queryItems.count, 1, @"There should be 1 query item generated.");
    XCTAssertEqualObjects(queryItems[0].name, @"ct", @"Query item name should be 'ct'.");
    XCTAssertEqualObjects(queryItems[0].value, name, @"Query item value should match the action name.");
}

- (void)testAsQueryItemsWithoutName {
    // Arrange
    MIActionEvent *actionEvent = [[MIActionEvent alloc] initWithName:nil];

    // Act
    NSMutableArray<NSURLQueryItem *> *queryItems = [actionEvent asQueryItems];

    // Assert
    XCTAssertNotNil(queryItems, @"Query items should not be nil.");
    XCTAssertEqual(queryItems.count, 0, @"There should be no query items generated when name is nil.");
}

@end
