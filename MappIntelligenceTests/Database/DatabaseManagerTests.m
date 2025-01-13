//
//  DatabaseManagerTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 04/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDatabaseManager.h"
#import "MIRequestData.h"

@interface DatabaseManagerTests : XCTestCase

@property MIDatabaseManager* dbManager;

@end

@implementation DatabaseManagerTests

- (void)setUp {
    _dbManager = [MIDatabaseManager shared];
}

- (void)tearDown {
    _dbManager = nil;
}

- (void)testInsertRequest {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until red from database!"];
    
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    MIDBRequest* request = [[MIDBRequest alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager deleteAllRequest];
    [_dbManager insertRequest:request];
    usleep(1000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        BOOL testRequestFlag = NO;
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            for (MIDBRequest* r in dt.requests) {
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
    MIDBRequest* request = [[MIDBRequest alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager deleteAllRequest];
    [_dbManager insertRequest:request];
    usleep(1000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        BOOL testRequestFlag = NO;
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            for (MIDBRequest* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                    testRequestFlag = YES;
                    //remove request
                    [self->_dbManager deleteRequest:[r.uniqueId intValue]];
                    usleep(1000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        BOOL testRequestFlag = NO;
                        if (!error) {
                            MIRequestData* dt = (MIRequestData*)data;
                            for (MIDBRequest* r in dt.requests) {
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
    MIDBRequest* request = [[MIDBRequest alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager deleteAllRequest];
    [_dbManager insertRequest:request];
    usleep(1000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            for (MIDBRequest* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1Name"]) {
                    [self->_dbManager deleteAllRequest];
                    usleep(1000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        MIRequestData* dt = (MIRequestData*)data;
                        XCTAssertTrue([dt requests].count == 0, @"The whole database wasn't deleted!");
                        if ([dt requests].count == 0) {
                            [expectation fulfill];
                        }
                    }];
                }
            }
            if ([dt requests].count == 0) {
                [expectation fulfill];
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
    MIDBRequest* request1 = [[MIDBRequest alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    
    item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1ValueForRequest2"];
    item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2ValueForRequest2"];
    NSArray* array2 = [NSArray arrayWithObjects:item1, item2, nil];
    MIDBRequest* request2 = [[MIDBRequest alloc] initWithParamters:array2 andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager deleteAllRequest];
    
    //2. insert two requests
    [_dbManager insertRequest:request1];
    [_dbManager insertRequest:request2];
    
    //3.check if there is two requests
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        BOOL testRequest1Flag = NO;
        BOOL testRequest2Flag = NO;
        NSMutableArray * requestIds = [[NSMutableArray alloc] init];
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            for (MIDBRequest* r in dt.requests) {
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
                MIRequestData* dt = (MIRequestData*)data;
                for (MIDBRequest* r in dt.requests) {
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
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until change status of request!"];
    
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1NameStatusUpdate" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    MIDBRequest* request = [[MIDBRequest alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
    [_dbManager deleteAllRequest];
    [_dbManager insertRequest:request];
    //usleep(3000000);
    [_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            for (MIDBRequest* r in dt.requests) {
                if ([r.parameters[0].name isEqualToString:@"parameter1NameStatusUpdate"]) {
                    [self->_dbManager updateStatusOfRequestWithId:[r.uniqueId intValue] andStatus:FAILED];
                    usleep(3000000);
                    [self->_dbManager fetchAllRequestsFromInterval:15*100 andWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
                        BOOL testRequestFlag = NO;
                        if (!error) {
                            MIRequestData* dt = (MIRequestData*)data;
                            for (MIDBRequest* r in dt.requests) {
                                if ([r.parameters[0].name isEqualToString:@"parameter1NameStatusUpdate"] && ([r status] == FAILED)) {
                                    testRequestFlag = YES;
                                    XCTAssertTrue(testRequestFlag, @"The request is not written into database!");
                                    [expectation fulfill];
                                    break;
                                }
                            }
                            
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
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:35];
    
}

- (void)testPerformanceExample {
    [self measureBlock:^{
    }];
}

//This tests write 10k request and it only for internal testing
//- (void)testSequentialRequestInsert {
//        XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until all inserts finish!"];
//
//        NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
//        NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
//        NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
//        Request* request = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
//
//        for (int i=0; i<10000; i++) {
//            [_dbManager insertRequest:request];
//        }
//
//        dispatch_queue_t queue = [_dbManager getExecutionQueue];
//        dispatch_sync(queue, ^{
//            [expectation fulfill];
//        });
//        [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:50];
//}
//
//- (void)testBatchRequestsInsert {
//        XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until db opearion is finished!"];
//
//        NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
//        NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
//        NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
//
//        Request* request = [[Request alloc] initWithParamters:array andDomain:@"https://q3.webtrekk.net" andTrackIds:@"385255285199574"];
//
//        NSMutableArray *requests = [[NSMutableArray alloc] init];
//        for (int i=0; i<10000; i++) {
//            [requests addObject:request];
//        }
//        [_dbManager insertRequests:requests];
//        dispatch_queue_t queue = [_dbManager getExecutionQueue];
//        dispatch_sync(queue, ^{
//            [expectation fulfill];
//        });
//        [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:50];
//}

@end
