//
//  APXMIUMRequestTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "APXRequest.h"

@interface MIUMRequestTests : XCTestCase

@property (nonatomic, strong) MIUMRequest *request;

@end

@implementation MIUMRequestTests

- (void)setUp {
    [super setUp];
    self.request = [[MIUMRequest alloc] init];
}

- (void)tearDown {
    self.request = nil;
    [super tearDown];
}

#pragma mark - Test addKeyedValues:forKeyType:

- (void)testAddKeyedValuesForKeyType_ActionSet {
    NSDictionary *values = @{@"key1": @"value1", @"key2": @"value2"};
    
    [self.request addKeyedValues:values forKeyType:kAPXRequestKeyTypeActionSet];
    
    NSDictionary *result = [self.request dictionaryWithValuesForKeys:@[]];
    
    NSDictionary *expected = @{
        @"actions": @{
            @"set": values
        }
    };
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testAddKeyedValuesForKeyType_ApplicationTags {
    NSDictionary *values = @{@"tag1": @"value1", @"tag2": @"value2"};
    
    [self.request addKeyedValues:values forKeyType:kAPXRequestKeyTypeGetAppAndDeviceTags];
    
    NSDictionary *result = [self.request dictionaryWithValuesForKeys:@[]];
    
    NSDictionary *expected = @{
        @"actions": values
    };
    
    XCTAssertEqualObjects(result, expected);
}

- (void)testAddKeyedValuesForKeyType_CustomFields {
    NSDictionary *values = @{@"customField1": @"value1", @"customField2": @"value2"};
    
    [self.request addKeyedValues:values forKeyType:kAPXRequestKeyTypeGetCustomFields];
    
    NSDictionary *result = [self.request dictionaryWithValuesForKeys:@[]];
    
    NSDictionary *expected = @{
        @"actions": values
    };
    
    XCTAssertEqualObjects(result, expected);
}


#pragma mark - Test dictionaryWithValuesForKeys:

- (void)testDictionaryWithValuesForKeys {
    NSDictionary *actionsSetters = @{@"setKey": @"setValue"};
    NSDictionary *actions = @{@"actionKey": @"actionValue"};
    
    [self.request addKeyedValues:actionsSetters forKeyType:kAPXRequestKeyTypeActionSet];
    [self.request addKeyedValues:actions forKeyType:kAPXRequestKeyTypeReportPushOpen];
    
    NSDictionary *result = [self.request dictionaryWithValuesForKeys:@[]];
    
    NSDictionary *expected = @{
        @"actions": @{
            @"push_open": actions,
            @"set": actionsSetters
        }
    };
    
    XCTAssertEqualObjects(result, expected);
}

@end
