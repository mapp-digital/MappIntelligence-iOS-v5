//
//  RequestTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Request.h"

@interface RequestTest : XCTestCase

@property Request* request;
@property NSDate* date;
@property NSDictionary* keyedValues;

@end

@implementation RequestTest

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
    _request = [[Request alloc] initWithKeyedValues:_keyedValues];
}

- (void)testInitWithKeyedValues {
    XCTAssertTrue([_request.uniqueId isEqualToNumber:@123456], @"Request ID is not same as we set it into test!");
    XCTAssertTrue([_request.domain isEqualToString:@"www.domain.com"], @"Request domain is not same as we set it into test!");
    XCTAssertTrue([_request.track_ids isEqualToString:@"12,34"], @"Request track ids is not same as we set it into test!");
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
    _request = [[Request alloc] initWithParamters:parametrs andDomain:@"www.domain.com" andTrackIds:@"12,34"];
    
    XCTAssertTrue([_request.domain isEqualToString:@"www.domain.com"], @"Request domain is not same as we set it into test!");
    XCTAssertTrue([_request.track_ids isEqualToString:@"12,34"], @"Request track ids is not same as we set it into test!");
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
    _request = [[Request alloc] initWithParamters:parametrs andDomain:@"www.domain.com" andTrackIds:@"12,34"];
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
