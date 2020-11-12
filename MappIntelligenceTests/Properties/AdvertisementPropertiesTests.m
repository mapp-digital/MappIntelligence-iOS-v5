//
//  AdvertisementPropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 10/11/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AdvertisementProperties.h"

@interface AdvertisementPropertiesTests : XCTestCase
@property AdvertisementProperties* advertisementProperties;
@property NSMutableDictionary* properties;
@end

@implementation AdvertisementPropertiesTests

- (void)setUp {
    _advertisementProperties = [[AdvertisementProperties alloc] initWith: @"en.internal.newsletter.2017.05"];
    _advertisementProperties.mediaCode = @"abc";
    _advertisementProperties.oncePerSession = YES;
    _advertisementProperties.action = view;
    
    _properties = [@{@1: @[@"ECOMM"]} copy];
    _advertisementProperties.customProperties = _properties;
}

- (void)tearDown {
    _advertisementProperties = nil;
}

- (void)testInitWithCustomProperties {
    XCTAssertTrue([_advertisementProperties.customProperties isEqual:_properties], @"The custom properties are not correct!");
}

- (void)testCopy {
    AdvertisementProperties *comparable = [[AdvertisementProperties alloc] initWith: @"en.internal.newsletter.2017.05"];
    comparable.mediaCode = @"abc";
    comparable.oncePerSession = YES;
    comparable.action = view;
    
    _properties = [@{@1: @[@"ECOMM"]} copy];
    comparable.customProperties = _properties;
    XCTAssertTrue([_advertisementProperties isEqual:comparable], @"Objects are not equal!");
}

@end
