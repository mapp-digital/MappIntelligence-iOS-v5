//
//  MIDBRequestTests.m
//  MappIntelligenceTests
//
//  Created by Codex on 2026-03-05.
//

#import <XCTest/XCTest.h>
#import "MIDBRequest.h"
#import "MIParameter.h"

@interface MIDBRequest (TestAccess)
- (NSMutableArray<NSURLQueryItem *> *)convertParamtersWith:(BOOL)batch;
@end

@interface MIDBRequestTests : XCTestCase
@end

@implementation MIDBRequestTests

- (void)testInitWithKeyedValuesParsesFieldsAndStatus {
    NSString *dateString = @"2024-01-02 03:04:05";
    NSDictionary *values = @{
        @"id": @42,
        @"track_domain": @"https://example.com",
        @"track_ids": @"123,456",
        @"status": @1,
        @"date": dateString
    };

    MIDBRequest *request = [[MIDBRequest alloc] initWithKeyedValues:values];

    XCTAssertEqualObjects(request.uniqueId, @42);
    XCTAssertEqualObjects(request.domain, @"https://example.com");
    XCTAssertEqualObjects(request.track_ids, @"123,456");
    XCTAssertEqual(request.status, SENT);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *expectedDate = [formatter dateFromString:dateString];
    XCTAssertEqualObjects(request.date, expectedDate);
}

- (void)testDictionaryWithValuesForKeysIncludesStatusAndDate {
    MIDBRequest *request = [[MIDBRequest alloc] init];
    request.uniqueId = @7;
    request.domain = @"https://example.com";
    request.track_ids = @"1,2";
    request.status = FAILED;

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:@"2024-03-04 05:06:07"];
    request.date = date;

    MIParameter *param = [[MIParameter alloc] initWithKeyedValues:@{ @"name": @"cs801", @"value": @"1" }];
    request.parameters = [NSMutableArray arrayWithObject:param];

    NSDictionary *dictionary = [request dictionaryWithValuesForKeys];

    XCTAssertEqualObjects(dictionary[@"id"], @7);
    XCTAssertEqualObjects(dictionary[@"track_domain"], @"https://example.com");
    XCTAssertEqualObjects(dictionary[@"track_ids"], @"1,2");
    XCTAssertEqualObjects(dictionary[@"status"], @2);
    XCTAssertEqualObjects(dictionary[@"date"], @"2024-03-04 05:06:07");
    XCTAssertNotNil(dictionary[@"parameters"]);
}

- (void)testConvertParametersWithBatchSkipsSpecialKeys {
    MIDBRequest *request = [[MIDBRequest alloc] init];

    MIParameter *eid = [[MIParameter alloc] initWithKeyedValues:@{ @"name": @"eid", @"value": @"1" }];
    MIParameter *ua = [[MIParameter alloc] initWithKeyedValues:@{ @"name": @"X-WT-UA", @"value": @"ua" }];
    MIParameter *nc = [[MIParameter alloc] initWithKeyedValues:@{ @"name": @"nc", @"value": @"1" }];
    MIParameter *cs = [[MIParameter alloc] initWithKeyedValues:@{ @"name": @"cs801", @"value": @"2" }];

    request.parameters = [NSMutableArray arrayWithObjects:eid, ua, nc, cs, nil];

    NSArray<NSURLQueryItem *> *batchItems = [request convertParamtersWith:YES];
    NSArray<NSURLQueryItem *> *singleItems = [request convertParamtersWith:NO];

    XCTAssertEqual(batchItems.count, 1);
    XCTAssertEqualObjects(batchItems.firstObject.name, @"cs801");
    XCTAssertEqual(singleItems.count, 4);
}

- (void)testUrlForBatchSupportBuildsUrl {
    NSURLQueryItem *item = [[NSURLQueryItem alloc] initWithName:@"cs801" value:@"1"];
    MIDBRequest *request = [[MIDBRequest alloc] initWithParamters:@[item]
                                                        andDomain:@"https://example.com"
                                                      andTrackIds:@"111,222"];

    NSURL *url = [request urlForBatchSupprot:YES];
    XCTAssertNotNil(url);
    XCTAssertTrue([url.absoluteString containsString:@"example.com"]);
}

@end
