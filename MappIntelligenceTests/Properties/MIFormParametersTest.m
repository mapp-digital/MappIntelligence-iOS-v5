//
//  MIFormParametersTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 26.4.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIFormParameters.h"

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

@interface MIFormParametersTest : XCTestCase

@property NSString* formName;
@property NSMutableArray<NSNumber*>* fieldIds;
@property NSMutableDictionary* renameFields;
@property NSMutableDictionary* changeFieldsValue;
@property NSMutableArray<NSNumber*>* anonymousSpecificFields;
@property NSMutableArray<NSNumber*>* fullContentSpecificFields;
@property BOOL confirmButton;
@property NSNumber* anonymous;
@property NSMutableArray<NSNumber*>* pathAnalysis;

@property MIFormParameters* parameters;
@property MIFormParameters* parametersFromDictionary;
@property NSDictionary* dictionary;

@end

@implementation MIFormParametersTest

- (void)setUp {
}

- (void)setUpDictiponary {
    _formName = @"testFormName";
    _fieldIds = [@[@1, @2] copy];
    _renameFields = [@{@1: @"renameField1"} copy];
    _changeFieldsValue = [@{@2: @"changeNameField2"} copy];
    _anonymousSpecificFields = [@[@3, @4] copy];
    _fullContentSpecificFields = [@{@4: @"fullContentField4"} copy];
    _confirmButton = YES;
    _anonymous = [NSNumber numberWithBool:NO];
    _pathAnalysis = [@[@1, @2, @2, @4] copy];
    
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

}

@end
