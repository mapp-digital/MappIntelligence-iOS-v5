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

- (void)testDeleteRequest {
   XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete request from database!"];
   
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
                    //remove request
                    [self->_dbManager deleteRequest:[r.uniqueId intValue]];
                    usleep(1000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        BOOL testRequestFlag = NO;
                        if (!error) {
                            RequestData* dt = (RequestData*)data;
                            for (Request* r in dt.requests) {
                                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                                    testRequestFlag = YES;
                                }
                            }
                        }
                        XCTAssertFalse(testRequestFlag, @"The request was not deleted from database!");
                        [expectation fulfill];
                    }];
                }
            }
        } else {
            XCTAssertTrue(NO, @"The database return error!");
        }
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:15];
}

- (void)testDeleteAllRequests {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete whole database!"];
    
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    Request* request = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager insertRequest:request];
    usleep(1000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            RequestData* dt = (RequestData*)data;
            for (Request* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                    [self->_dbManager deleteAllRequest];
                    usleep(1000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        RequestData* dt = (RequestData*)data;
                        XCTAssertTrue([dt requests].count == 0, @"The whole database wasn't deleted!");
                        if ([dt requests].count == 0) {
                            [expectation fulfill];
                        }
                    }];
                }
            }
        } else {
            XCTAssertTrue(NO, @"The database return error!");
        }
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:15];
}

- (void)testRemoveOldRequestsWithCompletitionHandler {
    //TODO: think about how to simulate 14 days old requests
}

- (void)testRemoveRequestsDB {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete requests from database!"];
    
    //1. create two requests
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    Request* request1 = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    
    item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1ValueForRequest2"];
    item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2ValueForRequest2"];
    NSArray* array2 = [NSArray arrayWithObjects:item1, item2, nil];
    Request* request2 = [[Request alloc] initWithParamters:array2 andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    
    //2. insert two requests
    [_dbManager insertRequest:request1];
    [_dbManager insertRequest:request2];
    
    //3.check if there is two requests
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        BOOL testRequest1Flag = NO;
        BOOL testRequest2Flag = NO;
        NSMutableArray * requestIds = [[NSMutableArray alloc] init];
        if (!error) {
            RequestData* dt = (RequestData*)data;
            for (Request* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                    testRequest1Flag = YES;
                    [requestIds addObject:r.uniqueId];
                }
                if ([r.parameters[0].value isEqualToString:@"parameter1ValueForRequest2"]) {
                    testRequest2Flag = YES;
                    [requestIds addObject:r.uniqueId];
                }
            }
        } else {
            XCTAssertTrue(NO, @"The database return error!");
        }
        XCTAssertTrue((testRequest1Flag && testRequest2Flag), @"The request is not written into database!");
        //4. removes two requests
        [self->_dbManager removeRequestsDB:[[NSArray alloc] initWithArray:requestIds]];
        usleep(1000000);
        //5. check if the requests are removed
        [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
            BOOL testRequest1Flag = NO;
            BOOL testRequest2Flag = NO;
            if (!error) {
                RequestData* dt = (RequestData*)data;
                for (Request* r in dt.requests) {
                    if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                        testRequest1Flag = YES;
                    }
                    if ([r.parameters[0].value isEqualToString:@"parameter1ValueForRequest2"]) {
                        testRequest2Flag = YES;
                    }
                }
            } else {
                XCTAssertTrue(NO, @"The database return error!");
            }
            XCTAssertFalse((testRequest1Flag && testRequest2Flag), @"The request is not written into database!");
            [expectation fulfill];
        }];
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:5];
    
}

- (void)testUpdateStatusOfRequestWithId {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete whole database!"];
    
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1NameStatusUpdate" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    Request* request = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager insertRequest:request];
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            RequestData* dt = (RequestData*)data;
            for (Request* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1NameStatusUpdate"] && ([r status] == ACTIVE)) {
                    [self->_dbManager updateStatusOfRequestWithId:[r.uniqueId intValue] andStatus:FAILED];
                    usleep(1000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        BOOL testRequestFlag = NO;
                        if (!error) {
                            RequestData* dt = (RequestData*)data;
                            for (Request* r in dt.requests) {
                                if ([r.parameters[0].name isEqualToString:@"parameter1NameStatusUpdate"] && ([r status] == FAILED)) {
                                    testRequestFlag = YES;
                                    break;
                                }
                            }
                            XCTAssertTrue(testRequestFlag, @"The request is not written into database!");
                        } else {
                            XCTAssertTrue(NO, @"The database return error!");
                        }
                        [expectation fulfill];
                    }];
                    break;
                }
            }
        } else {
            XCTAssertTrue(NO, @"The database return error!");
        }
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:20];
    
}

- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

@end
