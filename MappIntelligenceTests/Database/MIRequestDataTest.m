//
//  RequestDataTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIRequestData.h"
#import "MIDBRequest.h"
#import "MITrackerRequest.h"
#import "MappIntelligenceLogger.h"
#import "MIDatabaseManager.h"

@interface MIRequestDataTest : XCTestCase

@property MIRequestData* requestData;
@property NSDate* date;
@property NSDateFormatter* dateFormatter;
@property MIDBRequest* request1;
@property MIDBRequest* request2;
@property NSDictionary *keyedValues;
@property (nonatomic, strong) MappIntelligenceLogger *mockLogger;

@end

@implementation MIRequestDataTest

- (void)setUp {
    _requestData = [[MIRequestData alloc] init];
    self.mockLogger = [MappIntelligenceLogger shared];
    NSString *dateStr = @"2020-08-27 17:16:32";
    // Convert string to date object
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _date = [_dateFormatter dateFromString:dateStr];
    NSDictionary* keyedValues = @{
      @"id" : @123456,
      @"track_domain" : @"https://www.domain.com",
      @"track_ids" : @"12,34",
      @"status" : @1,
      @"date" : [_dateFormatter stringFromDate:_date]
    };
    _request1 = [[MIDBRequest alloc] initWithKeyedValues:keyedValues];
    
    keyedValues = @{
      @"id" : @7891234,
      @"track_domain" : @"https://www.domain.com",
      @"track_ids" : @"56,78",
      @"status" : @1,
      @"date" : [_dateFormatter stringFromDate:_date]
    };
    _request2 = [[MIDBRequest alloc] initWithKeyedValues:keyedValues];
    _keyedValues = @{
    @"requests" :
            @[@{
                      @"id" : @123456,
                      @"track_domain" : @"https://www.domain.com",
                      @"track_ids" : @"12,34",
                      @"status" : @1,
                      @"date" : [_dateFormatter stringFromDate:_date]
                    },
                    @{
                      @"id" : @7891234,
                      @"track_domain" : @"https://www.domain.com",
                      @"track_ids" : @"56,78",
                      @"status" : @1,
                      @"date" : [_dateFormatter stringFromDate:_date]
                    }]
    };
}

- (void)tearDown {
    self.mockLogger = nil;
    _requestData = nil;
    _date = nil;
    _dateFormatter = nil;
    _request1 = nil;
    _request2 = nil;
    _keyedValues = nil;
}

- (void)testInitWithRequests {
    NSMutableArray<MIDBRequest*>* requests = [[NSMutableArray alloc] init];
    [requests addObject:_request1];
    [requests addObject:_request2];
    _requestData = [[MIRequestData alloc] initWithRequests:requests];
    XCTAssertTrue([[[_requestData requests] firstObject] isEqual:_request1], "The first request is not the same as we put into request data object!");
    XCTAssertTrue([[[_requestData requests] lastObject] isEqual:_request2], "The last request is not the same as we put into request data object!");
}

- (void)testInitWithKeyedValues {
    _requestData = [[MIRequestData alloc] initWithKeyedValues:_keyedValues];
    XCTAssertTrue([[[_requestData requests] firstObject] isEqual:_request1], "The first request is not the same as we put into request data object!");
    XCTAssertTrue([[[_requestData requests] lastObject] isEqual:_request2], "The last request is not the same as we put into request data object!");
}

- (void)testDictionaryWithValuesForKeys {
    _requestData = [[MIRequestData alloc] initWithKeyedValues:_keyedValues];
    
    NSDictionary* dictionaryForTest = [_requestData dictionaryWithValues];
    
    XCTAssertTrue([dictionaryForTest isEqualToDictionary:_keyedValues], @"Returned dictionary is not the same as we use for creation of request data!");
}

- (void)testPrint {
    _requestData = [[MIRequestData alloc] initWithKeyedValues:_keyedValues];
    NSString* expectedString = @"ID: 123456 and domain: https://www.domain.com and ids: 12,34 and date: 2020-08-27 15:16:32 +0000 and paramters: ID: 7891234 and domain: https://www.domain.com and ids: 56,78 and date: 2020-08-27 15:16:32 +0000 and paramters: ";
    NSString* printedString = [_requestData print];
    XCTAssertTrue([expectedString isEqualToString:printedString], @"The printed string is not the same as we expect for requested data!");
}

- (void)testSendAllRequests {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until delete requests from database!"];
    MIParameter* paramter = [[MIParameter alloc] initWithKeyedValues: @{@"name" : @"item.name", @"value" : @"item.value"}];
    NSMutableArray<MIParameter*>* paramters = [[NSMutableArray alloc] initWithObjects:paramter, nil];
    [_request1 setParameters:paramters];
    _requestData = [[MIRequestData alloc] initWithRequests:@[_request1]];
    
    [_requestData sendAllRequestsWithCompletitionHandler:^(NSError * _Nullable error) {
        XCTAssertNil(error, @"There was an error wile sending all all requests!");
        [expectation fulfill];
    }];
    [self waitForExpectations:[NSArray arrayWithObject:expectation] timeout:50];
}

- (void)testInitWithRequestsSecond {
    NSArray *mockRequests = @[[[MIDBRequest alloc] initWithKeyedValues:@{@"key": @"value"}]];
    self.requestData = [[MIRequestData alloc] initWithRequests:mockRequests];
    
    XCTAssertNotNil(self.requestData.requests);
    XCTAssertEqual(self.requestData.requests.count, 1);
}

- (void)testSetValuesForKeysWithDictionary {
    [self.requestData setValuesForKeysWithDictionary:_keyedValues];
    
    XCTAssertEqual(self.requestData.requests.count, 2);
}

- (void)testDictionaryWithValues {
    [self.requestData setValuesForKeysWithDictionary:_keyedValues];
    
    NSDictionary *output = [self.requestData dictionaryWithValues];
    XCTAssertNotNil(output);
    XCTAssertEqual(output.count, 1);
}

- (void)testPrintSecond {
    NSDictionary *keyedValues = @{@"key": @"value"};
    [self.requestData setValuesForKeysWithDictionary:keyedValues];
    
    NSString *output = [self.requestData print];
    XCTAssertNotNil(output);
    // Depending on how print is implemented in MIDBRequest, you may want to check specific content.
}

@end
