//
//  APXMIRequestBuilder.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APXRequestBuilder.h"
#import "APXRequestBuilder.h"

@interface MIRequestBuilder (Test)

- (NSString *)deviceUniqueGlobaldentifier;
@property (nonatomic, strong) MIUMRequest *request;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *aliasValue;

@end

@interface MIRequestBuilderTests : XCTestCase

@property (nonatomic, strong) MIRequestBuilder *builder;

@end

@implementation MIRequestBuilderTests

- (void)setUp {
    [super setUp];
    self.builder = [MIRequestBuilder builder];
}

- (void)tearDown {
    self.builder = nil;
    [super tearDown];
}

#pragma mark - Test Singleton

- (void)testSingletonInstance {
    MIRequestBuilder *firstInstance = [MIRequestBuilder shared];
    MIRequestBuilder *secondInstance = [MIRequestBuilder shared];
    
    XCTAssertEqual(firstInstance, secondInstance, @"The shared instance should return the same object every time.");
}

#pragma mark - Test deviceUniqueGlobaldentifier

- (void)testDeviceUniqueGlobaldentifier {
    NSString *udid = [self.builder deviceUniqueGlobaldentifier];
    
    XCTAssertNotNil(udid, @"The device unique identifier should not be nil.");
    XCTAssertTrue([udid isKindOfClass:[NSString class]], @"The device unique identifier should be of type NSString.");
    
    NSString *storedUdid = [[NSUserDefaults standardUserDefaults] objectForKey:@"UDID_USER_DEFAULTS_KEY"];
    XCTAssertEqualObjects(udid, storedUdid, @"The UDID should be stored in NSUserDefaults.");
}

#pragma mark - Test addRequestKeyedValues:forRequestType:

- (void)testAddRequestKeyedValues {
    NSDictionary *testValues = @{@"key1": @"value1", @"key2": @"value2"};
    
    [self.builder addRequestKeyedValues:testValues forRequestType:kAPXRequestKeyTypeRegister];
    
    NSDictionary *requestDict = [self.builder.request dictionaryWithValuesForKeys:@[]];
    NSDictionary *expected = @{@"actions": @{@"register": testValues}};
    
    XCTAssertEqualObjects(requestDict, expected, @"The keyed values should be correctly added to the request.");
}

#pragma mark - Test buildRequestAsJsonData

- (void)testBuildRequestAsJsonData {
    NSDictionary *testValues = @{@"key1": @"value1", @"key2": @"value2"};
    [self.builder addRequestKeyedValues:testValues forRequestType:kAPXRequestKeyTypeRegister];
    
    NSData *jsonData = [self.builder buildRequestAsJsonData];
    
    XCTAssertNotNil(jsonData, @"The JSON data should not be nil.");
    
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    XCTAssertNil(error, @"There should not be an error when converting JSON data.");
    
    NSDictionary *expected = @{
        @"actions": @{@"register": testValues}
    };
    
    XCTAssertEqualObjects(jsonDict[@"actions"], expected[@"actions"], @"The generated JSON data should match the expected dictionary.");
}

#pragma mark - Test dictionaryWithValuesForKeys

- (void)testDictionaryWithValuesForKeys {
    NSDictionary *testValues = @{@"key1": @"value1"};
    [self.builder addRequestKeyedValues:testValues forRequestType:kAPXRequestKeyTypeRegister];
    
    NSDictionary *resultDict = [self.builder dictionaryWithValuesForKeys:@[]];
    
    NSMutableDictionary *expectedDict = [@{
        @"actions": @{@"register": testValues},
        @"key": self.builder.key,
        @"alias": self.builder.aliasValue ? : @""
    } copy];
    if (!self.builder.aliasValue) {
        expectedDict = [@{
            @"actions": @{@"register": testValues},
            @"key": self.builder.key
        } copy];
    }
    
    XCTAssertEqualObjects(resultDict, expectedDict, @"The dictionary should contain the correct key, alias, and actions.");
}

@end

