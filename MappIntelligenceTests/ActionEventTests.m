//
//  ActionEventTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 10/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIActionEvent.h"

@interface ActionEventTests : XCTestCase
@property NSMutableDictionary* details;
@property MIActionEvent* actionEvent;
@property MIActionProperties* actionProperties;
@property NSMutableDictionary *sessionDictionary;
@property MISessionProperties *sessionProperties;
@property MIUserProperties *userProperties;
@property MIEcommerceProperties *ecommerceProperties;
@property MICampaignProperties *advertisementProperties;

@end

@implementation ActionEventTests

- (void)setUp {
    _details = [@{@20: @"ck20Override"} copy];
    _actionProperties = [[MIActionProperties alloc] initWithProperties: _details];
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[MISessionProperties alloc] initWithProperties: _sessionDictionary];
    _userProperties = [[MIUserProperties alloc] init];
    _userProperties.city = @"Berlin";
    _ecommerceProperties = [[MIEcommerceProperties alloc] init];
    MIProduct* product1 = [[MIProduct alloc] init];
    product1.name = @"product1";
   // product1.price = @"33$";
    product1.quantity = [[NSNumber alloc] initWithInteger:22];
    MIProduct* product2 = [[MIProduct alloc] init];
    product2.name = @"product2";
    _ecommerceProperties.products = [[NSArray alloc] initWithObjects:product1, product2, nil];
    _advertisementProperties = [[MICampaignProperties alloc] initWith: @"en.internal.newsletter.2017.05"];
    _advertisementProperties.mediaCode = @"abc";
    _advertisementProperties.oncePerSession = YES;
    _advertisementProperties.action = view;
    _advertisementProperties.customProperties = @{@1: @[@"ECOMM"]};
    _actionEvent = [[MIActionEvent alloc] initWithName:@"TestAction"];
    _actionEvent.actionProperties = _actionProperties;
    _actionEvent.sessionProperties = _sessionProperties;
    _actionEvent.userProperties = _userProperties;
    _actionEvent.ecommerceProperties = _ecommerceProperties;
    _actionEvent.campaignProperties = _advertisementProperties;
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
    XCTAssertTrue([[_actionEvent actionProperties] isEqual:_actionProperties], @"Action properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent sessionProperties] isEqual:_sessionProperties], @"Session properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent userProperties] isEqual:_userProperties], @"User properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent ecommerceProperties] isEqual: _ecommerceProperties], @"Ecommerce properties is not the same as it used for creation of page view event!");
    XCTAssertTrue([[_actionEvent campaignProperties] isEqual: _advertisementProperties], @"Advertisement properties is not the same as it used for creation of page view event!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
