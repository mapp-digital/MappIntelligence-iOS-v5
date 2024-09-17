//
//  MIFormParameterTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 16.9.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormParameters.h"
#import "MIFormField.h"

#define key_form_name @"form_name"
#define key_field_ids @"field_ids"
#define key_rename_ids @"rename_ids"
#define key_change_fields_value @"change_fields_value"
#define key_anonymous_specific_fields @"anonymous_specific_fields"
#define key_full_content_specific_fields @"full_content_specific_fields"
#define key_confirm_button @"confirm_button"
#define key_anonymous @"anonymous"
#define key_path_analysis @"path_analysis"

#define key_form_submit @"mi_form_submit"
#define key_form_fields @"mi_form_fields"

@interface MIFormParameterTests : XCTestCase

@end

@implementation MIFormParameterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithDictionary {
    NSMutableArray<NSNumber*>* field_ids_array = [[NSMutableArray alloc] initWithObjects:@1, @2, nil];
    NSDictionary* rename_ids_dict = @{@1: @"Field One", @2: @"Field Two"};
    NSArray<NSNumber*>* path_analysis_array = @[@1, @2];
    NSDictionary *dict = @{
        key_form_name: @"Test Form",
        key_field_ids: field_ids_array,
        key_rename_ids: rename_ids_dict,
        key_change_fields_value: @{@1: @"New Value"},
        key_anonymous_specific_fields: @[@1],
        key_full_content_specific_fields: @[@2],
        key_confirm_button: @YES,
        key_anonymous: @NO,
        key_path_analysis: path_analysis_array,
        key_form_fields: @[@{@"id": @1, @"name": @"Field1", @"content": @"Content1"}, @{@"id": @2, @"name": @"Field2", @"content": @"Content2"}]
    };

    MIFormParameters *parameters = [[MIFormParameters alloc] initWithDictionary:dict];
    
    XCTAssertEqualObjects(parameters.formName, @"Test Form");
    XCTAssertEqualObjects(parameters.fieldIds, field_ids_array);
    XCTAssertEqualObjects(parameters.renameFields, rename_ids_dict);
    XCTAssertEqualObjects(parameters.changeFieldsValue, @{@1: @"New Value"});
    XCTAssertEqualObjects(parameters.anonymousSpecificFields, @[@1]);
    XCTAssertEqualObjects(parameters.fullContentSpecificFields, @[@2]);
    XCTAssertTrue(parameters.confirmButton);
    XCTAssertEqual(parameters.anonymous, @NO);
    XCTAssertEqualObjects(parameters.pathAnalysis, path_analysis_array);
    XCTAssertTrue(parameters.fieldIds.count == 2);
}

- (void)testDefaultInitialization {
    MIFormParameters *parameters = [[MIFormParameters alloc] init];
    
    XCTAssertEqualObjects(parameters.formName, @"");
    XCTAssertEqualObjects(parameters.fieldIds, @[]);
    XCTAssertEqualObjects(parameters.renameFields, @{});
    XCTAssertEqualObjects(parameters.changeFieldsValue, @{});
    XCTAssertEqualObjects(parameters.anonymousSpecificFields, @[]);
    XCTAssertEqualObjects(parameters.fullContentSpecificFields, @[]);
    XCTAssertEqual(parameters.confirmButton, YES);
    XCTAssertEqualObjects(parameters.pathAnalysis, @[]);
}


@end
