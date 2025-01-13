//
//  RequestTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIDBRequest.h"
#define key_id @"id"
#define key_domain @"track_domain"
#define key_ids @"track_ids"
#define key_status @"status"
#define key_date @"date"
#define key_parameters @"parameters"

@interface MIRequestTest : XCTestCase

@property MIDBRequest* request;
@property NSDate* date;
@property NSDictionary* keyedValues;

@end

@implementation MIRequestTest

- (void)setUp {
    NSString *dateStr = @"2020-08-27 17:16:32";
    // Convert string to date object
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    _date = [dateFormatter dateFromString:dateStr];
    _keyedValues = @{
      @"id" : @123456,
      @"track_domain" : @"www.domain.com",
      @"track_ids" : @"12,34",
      @"status" : @0,
      @"date" : [dateFormatter stringFromDate:_date]
    };
    _request = [[MIDBRequest alloc] initWithKeyedValues:_keyedValues];
}

- (void)testInitWithKeyedValues {
    XCTAssertTrue([_request.uniqueId isEqualToNumber:@123456], @"Request ID is not same as we set it into test!");
    XCTAssertTrue([_request.domain isEqualToString:@"www.domain.com"], @"Request domain is not same as we set it into test!");
    XCTAssertTrue([_request.track_ids isEqualToString:@"12,34"], @"Request trackIDs is not same as we set it into test!");
    XCTAssertTrue((_request.status == ACTIVE), @"Request status is not same as we set it into test!");
    XCTAssertTrue([_request.date isEqualToDate:_date], @"Request date is not same as we set it into test!");
}

- (void)testInitWithParamters {
    NSMutableArray *parametrs = [[NSMutableArray alloc] init];
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eid"
                                                     value:@"6089777"]];
    [parametrs
        addObject:[NSURLQueryItem
                      queryItemWithName:@"fns"
                                  value:@"1"]];
    [parametrs
        addObject:[NSURLQueryItem
                      queryItemWithName:@"one"
                                  value:@"1"]];
    _request = [[MIDBRequest alloc] initWithParamters:parametrs andDomain:@"www.domain.com" andTrackIds:@"12,34"];
    
    XCTAssertTrue([_request.domain isEqualToString:@"www.domain.com"], @"Request domain is not same as we set it into test!");
    XCTAssertTrue([_request.track_ids isEqualToString:@"12,34"], @"Request trackIDs is not same as we set it into test!");
    XCTAssertTrue([[_request.parameters[0] value] isEqual:@"6089777"], @"Request parameters is not same as we set it into test!");
    XCTAssertTrue([[_request.parameters[1] value] isEqual:@"1"], @"Request parameters is not same as we set it into test!");
    XCTAssertTrue([[_request.parameters[2] value] isEqual:@"1"], @"Request parameters is not same as we set it into test!");
}

- (void)testDictionaryWithValuesForKeys {
    NSDictionary* tempDictionary = [_request dictionaryWithValuesForKeys];
    XCTAssertTrue([tempDictionary isEqualToDictionary:_keyedValues], "Returned dictionary is not same as we set it!");
}

- (void)testPrint {
    NSString* printedRequest = [_request print];
    XCTAssertTrue([printedRequest isEqualToString:@"ID: 123456 and domain: www.domain.com and ids: 12,34 and date: 2020-08-27 15:16:32 +0000 and paramters: "], @"The printed result is not the same as we set it into test!");
}

- (void)testUrlForBatchSupprot {
    NSMutableArray *parametrs = [[NSMutableArray alloc] init];
    [parametrs addObject:[NSURLQueryItem queryItemWithName:@"eid"
                                                     value:@"6089777"]];
    _request = [[MIDBRequest alloc] initWithParamters:parametrs andDomain:@"www.domain.com" andTrackIds:@"12,34"];
    NSURL* urlWithoutBatch = [_request urlForBatchSupprot:NO];
    XCTAssertTrue([[urlWithoutBatch description] isEqualToString:@"www.domain.com/12,34/wt?eid=6089777"], @"Url request without batch is not correct!");
    //we do not put eid or user client because it is same for every request and we spare the time
    NSURL* urlWitBatch = [_request urlForBatchSupprot:YES];
    XCTAssertTrue([[urlWitBatch description] isEqualToString:@"www.domain.com/12,34/wt?"], @"Url request without batch is not correct!");
}

- (void)tearDown {
    _keyedValues = nil;
    _request = nil;
    _date = nil;
}

- (void)testInitializationWithKeyedValuesUpdate {
    NSDictionary *input = @{
        @"id": @1,
        @"track_domain": @"https://example.com",
        @"track_ids": @"12345",
        @"status": @0,
        @"date": @"2023-10-01 12:00:00"
    };
    
    MIDBRequest *request = [[MIDBRequest alloc] initWithKeyedValues:input];
    
    XCTAssertNotNil(request, @"Request should be initialized");
    XCTAssertEqual(request.uniqueId.integerValue, 1, @"uniqueId should be set correctly");
    XCTAssertEqualObjects(request.domain, @"https://example.com", @"Domain should be set correctly");
    XCTAssertEqualObjects(request.track_ids, @"12345", @"Track IDs should be set correctly");
    XCTAssertEqual(request.status, ACTIVE, @"Status should be ACTIVE");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expectedDate = [dateFormatter dateFromString:@"2023-10-01 12:00:00"];
    XCTAssertEqualObjects(request.date, expectedDate, @"Date should be set correctly");
}

- (void)testInitializationWithParameters {
    NSArray<NSURLQueryItem *> *queryItems = @[
        [[NSURLQueryItem alloc] initWithName:@"param1" value:@"value1"],
        [[NSURLQueryItem alloc] initWithName:@"param2" value:@"value2"]
    ];
    
    MIDBRequest *request = [[MIDBRequest alloc] initWithParamters:queryItems andDomain:@"https://example.com" andTrackIds:@"12345"];
    
    XCTAssertNotNil(request, @"Request should be initialized");
    XCTAssertEqual(request.parameters.count, 2, @"Parameters count should be 2");
    XCTAssertEqualObjects(request.domain, @"https://example.com", @"Domain should be set correctly");
    XCTAssertEqualObjects(request.track_ids, @"12345", @"Track IDs should be set correctly");
}

- (void)testDictionaryWithValuesForKeysUpdated {
    MIDBRequest *request = [[MIDBRequest alloc] init];
    request.uniqueId = @1;
    request.domain = @"https://example.com";
    request.track_ids = @"12345";
    request.status = ACTIVE;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.date = [dateFormatter dateFromString:@"2023-10-01 12:00:00"];
    
    MIParameter *param1 = [[MIParameter alloc] initWithKeyedValues:@{@"name": @"param1", @"value": @"value1"}];
    request.parameters = [NSMutableArray arrayWithObject:param1];

    NSDictionary *result = [request dictionaryWithValuesForKeys];
    
    XCTAssertNotNil(result, @"Result dictionary should not be nil");
    XCTAssertEqual(result.count, 6, @"Result dictionary should contain 6 keys");
    XCTAssertEqual(result[key_id], request.uniqueId, @"uniqueId should be in the dictionary");
    XCTAssertEqualObjects(result[key_domain], request.domain, @"Domain should be in the dictionary");
    XCTAssertEqualObjects(result[key_ids], request.track_ids, @"Track IDs should be in the dictionary");
    XCTAssertEqual(result[key_status], @0, @"Status should be in the dictionary");
    
    NSString *expectedDateString = @"2023-10-01 12:00:00";
    XCTAssertEqualObjects(result[key_date], expectedDateString, @"Date should be in the dictionary");
}

- (void)testPrintMethod {
    MIDBRequest *request = [[MIDBRequest alloc] init];
    request.uniqueId = @1;
    request.domain = @"https://example.com";
    request.track_ids = @"12345";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    request.date = [dateFormatter dateFromString:@"2023-10-01 12:00:00"];
    
    MIParameter *param1 = [[MIParameter alloc] initWithKeyedValues:@{@"name": @"param1", @"value": @"value1"}];
    request.parameters = [NSMutableArray arrayWithObject:param1];
    
    NSString *result = [request print];
    
    NSString *expectedOutput = @"ID: 1 and domain: https://example.com and ids: 12345 and date: 2023-10-01 10:00:00 +0000 and paramters: \n\n name: param1, value: value1";
    XCTAssertTrue([result containsString:expectedOutput], @"Print method output should match expected output");
}

- (void)testIsEqual {
    MIDBRequest *request1 = [[MIDBRequest alloc] init];
    request1.uniqueId = @1;
    request1.domain = @"https://example.com";
    request1.track_ids = @"12345";
    
    MIDBRequest *request2 = [[MIDBRequest alloc] init];
    request2.uniqueId = @1;
    request2.domain = @"https://example.com";
    request2.track_ids = @"12345";
    
    XCTAssertTrue(request1.uniqueId == request2.uniqueId && request1.domain == request2.domain && request1.track_ids == request2.track_ids, @"Two requests with the same properties should be equal");
    
    request2.track_ids = @"54321";
    XCTAssertFalse(request1.uniqueId == request2.uniqueId && request1.domain == request2.domain && request1.track_ids == request2.track_ids, @"Requests with different track_ids should not be equal");
}

@end
