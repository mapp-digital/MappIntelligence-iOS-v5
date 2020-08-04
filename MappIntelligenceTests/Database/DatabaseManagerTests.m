//
//  DatabaseManagerTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 04/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DatabaseManager.h"
#import "RequestData.h"

@interface DatabaseManagerTests : XCTestCase

@property DatabaseManager* dbManager;

@end

@implementation DatabaseManagerTests

- (void)setUp {
    _dbManager = [DatabaseManager shared];
}

- (void)tearDown {
    _dbManager = nil;
}

- (void)testInsertRequest {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until red from database!"];
    
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    Request* request = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager insertRequest:request];
    usleep(1000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        BOOL testRequestFlag = NO;
        if (!error) {
            RequestData* dt = (RequestData*)data;
            for (Request* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                    testRequestFlag = YES;
                }
            }
        }
        XCTAssertTrue(testRequestFlag, @"The request is not written into database!");
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:5];
}

- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

@end
