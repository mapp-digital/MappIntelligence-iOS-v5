//
//  RequestBatchSupportUrlBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 04/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIRequestBatchSupportUrlBuilder.h"

@interface RequestBatchSupportUrlBuilderTests : XCTestCase

@property MIRequestBatchSupportUrlBuilder* batchUrlBuilder;

@end

@implementation RequestBatchSupportUrlBuilderTests

- (void)setUp {
    _batchUrlBuilder = [[MIRequestBatchSupportUrlBuilder alloc] init];
}

- (void)tearDown {
    _batchUrlBuilder = nil;
}

- (void)testSendBatchForRequestsWithCompletition {
    //TODO: fix this
//    [_batchUrlBuilder sendBatchForRequestsWithCompletition:^(NSError * _Nonnull error) {
//        XCTAssertNil(error, @"Send batch of requests failed!");
//    }];
}

//TODO: add test to send 10000 requests

@end
