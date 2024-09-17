//
//  MIFormFieldParameterTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 16.9.24..
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormField.h"

#define key_field_name @"mi_form_field_name"
#define key_field_content @"mi_field_content"
#define key_last_focus @"mi_last_focus"
#define key_anonymus @"mi_anonymus"

@interface MIFormFieldParameterTests : XCTestCase

@end

@implementation MIFormFieldParameterTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithDictionary {
    NSDictionary *dict = @{
        key_field_name: @"Test Field",
        key_field_content: @"Test Content",
        key_last_focus: @YES,
        key_anonymus: @NO
    };

    MIFormField *field = [[MIFormField alloc] initWithDictionary:dict];
    
    XCTAssertEqualObjects(field.formFieldName, @"Test Field");
    XCTAssertEqualObjects(field.formFieldContent, @"Test Content");
    XCTAssertEqual(field.lastFocus, YES);
    XCTAssertEqual(field.anonymus, NO);
}

- (void)testInitWithNameContentIDAnonymusAndFocus {
    MIFormField *field = [[MIFormField alloc] initWithName:@"Name" andContent:@"Content" andID:123 andWithAnonymus:NO andFocus:YES];
    
    XCTAssertEqualObjects(field.formFieldName, @"Name");
    XCTAssertEqualObjects(field.formFieldContent, @"Content");
    XCTAssertEqual(field.ID, 123);
    XCTAssertEqual(field.anonymus, NO);
    XCTAssertEqual(field.lastFocus, YES);
}

- (void)testInitWithRandomIDWhenIDIsZero {
    MIFormField *field = [[MIFormField alloc] initWithName:@"Name" andContent:@"Content" andID:0 andWithAnonymus:NO andFocus:NO];
    
    XCTAssertEqualObjects(field.formFieldName, @"Name");
    XCTAssertEqualObjects(field.formFieldContent, @"Content");
    XCTAssertNotEqual(field.ID, 0); // Ensure a random ID is assigned
    XCTAssertEqual(field.anonymus, NO);
    XCTAssertEqual(field.lastFocus, NO);
}

- (void)testSetFormFieldName {
    MIFormField *field = [[MIFormField alloc] init];
    field.formFieldName = @"Test Name";
    
    XCTAssertEqualObjects(field.formFieldName, @"Test Name");
    
    field.formFieldName = NULL;
    XCTAssertEqualObjects(field.formFieldName, NULL);
}

- (void)testSetFormFieldContent {
    MIFormField *field = [[MIFormField alloc] init];
    field.formFieldContent = @"Content";
    field.anonymus = NO;
    
    XCTAssertEqualObjects(field.formFieldContent, @"Content");
    
    // Test anonymous field
    field.anonymus = YES;
    field.formFieldContent = @"";
    XCTAssertEqualObjects(field.formFieldContent, @"");
    
    field.formFieldContent = @"mapp_inteligence_switch";
    XCTAssertEqualObjects(field.formFieldContent, @"mapp_inteligence_switch");
}

- (void)testSetLastFocus {
    MIFormField *field = [[MIFormField alloc] init];
    field.lastFocus = YES;
    
    XCTAssertEqual(field.lastFocus, YES);
    
    field.lastFocus = NO;
    XCTAssertEqual(field.lastFocus, NO);
}

- (void)testRenameField {
    MIFormField *field = [[MIFormField alloc] init];
    field.formFieldName = @"OriginalField.Name";
    
    [field renameField:@"NewField"];
    XCTAssertEqualObjects(field.formFieldName, @"NewField.Name");
}

- (void)testGetFormFieldForQuery {
    MIFormField *field = [[MIFormField alloc] init];
    field.formFieldName = @"Field1";
    field.formFieldContent = @"Content1";
    field.lastFocus = YES;
    
    NSString *expectedQuery = @"Field1|Content1|1";
    XCTAssertEqualObjects([field getFormFieldForQuery], expectedQuery);
    
    // Test with anonymus field and empty content
    field.anonymus = YES;
    field.formFieldContent = @"";
    expectedQuery = @"Field1|empty|1";
    XCTAssertEqualObjects([field getFormFieldForQuery], expectedQuery);
}

@end
